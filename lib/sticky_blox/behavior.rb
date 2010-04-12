require File.join( File.dirname(__FILE__), 'proc_extension' )

module StickyBlox
  def self.included(base)
    base.extend ClassMethods
  end
  
  class BindingArray < Array
    
    def bind(object)
      @binding = object
      self
    end
    
    def call(*args)
      value = @binding
      self.reject{|e| e.nil?}.each do |blk|
        value = blk.bind(value).call(*args)
      end
      value
    end
  end

  module ClassMethods
    def my_meta_class
      class << self; self; end
    end
    
    def stuck_methods
      my_meta_class.instance_eval do
        @stuck_methods ||= {}
        @stuck_methods
      end
    end

    # Defines methods on the class identified by "binding"
    # for each method in @stuck_methods that will call
    # the block associated with that method name, passing
    # any arguments that are defined at runtime
    def stick_to( binding )
      my_meta_class.instance_eval do
        clz = self
        @stuck_methods.each_pair do |method_name, binding_array|
          binding.class_eval do
            define_method method_name do | *args |
              binding_array.bind(self).call(*args)
            end
          end
        end
      end
    end

    def unstick_from( options={} )
      ignore_errors = options.delete(:ignore_errors)
      options.each_pair do |binding, method_names|
        method_names = [method_names].flatten
        method_names.each do |method_name|
          binding.class_eval do
            begin
              # remove_method removes it from a specific class, but not its parent
              # Do we want to use undef_method which will remove it from the whole
              # inheritance chain?
              remove_method method_name
            rescue NoMethodError => e
              # unless told otherwise, ignore the error -- if we don't respond to the method, no harm done.
              raise e unless ignore_errors
            end
          end if binding.instance_methods.detect{|e| e.to_s == method_name.to_s}
        end
      end
    end
    
    def unstick_all_from( binding, ignore_errors=true )
      unstick_from( binding => my_meta_class.instance_variable_get("@stuck_methods").keys, :ignore_errors => ignore_errors )
    end

    def stick(name, replace=false, &block)
      my_methods = stuck_methods
      if replace && my_methods.has_key?(name)
        my_methods.delete(name)
      end
      (my_methods[name] ||= BindingArray.new) << block

      my_methods = my_methods[name]
      self.class.class_eval do
        define_method name do
          my_methods
        end
      end
    end
  end
end
