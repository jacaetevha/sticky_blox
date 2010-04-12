require File.join( File.dirname(__FILE__), 'proc_extension' )

module StickyBlox
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def stick_to binding
      (class << self; self; end).instance_eval do
        clz = self
        @stuck_methods.each do |route_name|
          binding.class_eval do
            define_method route_name do | *args |
              clz.send(route_name).bind(self).call(*args)
            end
          end
        end
      end
    end

    def stick name, &block
      (class << self; self; end).instance_eval do
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
