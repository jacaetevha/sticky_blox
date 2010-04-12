begin
  Proc.instance_method(:bind)
rescue NameError
  # Proc instance don't respond to :bind, so let's define it
  class Proc
    # this was lifted from the facets project (facets.rubyforge.org)
    # which in turn was lifted from Rails
    def bind(object)
      block, time = self, Time.now
      (class << object; self; end).class_eval do
        method_name = "__bind_#{time.to_i}_#{time.usec}"
        define_method(method_name, &block)
        method = instance_method(method_name)
        remove_method(method_name)
        method
      end.bind(object)
    end
  end
end
