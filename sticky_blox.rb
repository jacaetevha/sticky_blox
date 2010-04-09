# Example: define a reloader for your route implementations
#   class ReloadableRoutes
#     include StickyBlox
#     stick :reload do
#       raise "no file specified" unless params[:file]
#       load params[:file]
#       "Success"
#     end
#   end
#
#  ReloadableRoutes.stick_to Sinatra::Application

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
