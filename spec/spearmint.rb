require File.join(File.dirname(__FILE__), '..', 'lib', 'sticky_blox')

class Spearmint
  include StickyBlox

  stick :chew do
    raise "ah, ah, ah ... I ain't no reverse-able object. I'm a #{self.class}" unless self.respond_to?(:reverse)
    self.reverse
  end

  stick :chew_it_up_and_spit_it_out do
    raise "ah, ah, ah ... I ain't no reverse-able object. I'm a #{self.class}" unless self.respond_to?(:reverse!)
    self.reverse!
  end
  
  stick :open do |how_many_pieces|
    (1..(how_many_pieces || self).to_i).collect
  end
end