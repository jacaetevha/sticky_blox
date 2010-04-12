require File.join( File.dirname(__FILE__), 'proc_extension' )

module StickyBlox
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def my_meta_class
      class << self; self; end
    end

    def stick_to( binding )
      my_meta_class.instance_eval do
        clz = self
        @stuck_methods.each do |method_name|
          binding.class_eval do
            define_method method_name do | *args |
              clz.send(method_name).bind(self).call(*args)
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
      unstick_from( binding => my_meta_class.instance_variable_get("@stuck_methods"), :ignore_errors => ignore_errors )
    end

    def stick name, &block
      my_meta_class.instance_eval do
        @stuck_methods ||= []
        @stuck_methods << name unless @stuck_methods.include?(name)
      end
      self.class.class_eval do
        define_method name do
          block
        end
      end
    end
  end
end
