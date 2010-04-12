require 'helper'

describe "Instance-based approaches" do
  class Doublemint < Spearmint
  end
  
  it "Doublemint shouldn't have sticks to use" do
    proc{Doublemint.stick_to Object}.should raise_error(NameError)
  end

  it 'should be bound to any string' do
    Spearmint.stick_to String
    s = "abc"
    s1 = s.chew
    s1.should == s.reverse
    
    s = "Spearmint"
    s2 = "tnimraepS"
    s1 = s.chew_it_up_and_spit_it_out
    s1.should == s2
    s1.should === s
  end
  
  it "should turn the String into an Integer and return an array of numbers" do
    thing = "2"
    thing.open.should == [1, 2]
    thing.open(5).should == [1, 2, 3, 4, 5]
  end
end

describe "Class-based approaches" do
  it 'should be able to bind to the instance of any object' do
    s  = %w{a b c}
    s1 = Spearmint.chew.bind(s).call
    s1.should == %w{c b a}
    
    s  = %w{a b c}
    s2 = %w{c b a}
    s1 = Spearmint.chew_it_up_and_spit_it_out.bind(s).call
    s1.should == s2
    s1.should == s
  end
  
  it "should throw an error when binding to something other than a String" do
    thing = Object.new
    proc {Spearmint.chew.bind(thing).call}.should raise_error
  end
end