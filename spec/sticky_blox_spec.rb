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
    Spearmint.stick_to String
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

describe "Overriding stuck methods" do
  before :all do
    @original = Spearmint.chew.dup
    Spearmint.class_eval do
      stick :chew, true do
        self.upcase
      end
    end
  end
  
  after :all do
    Spearmint.chew.clear
    @original.each {|e| Spearmint.chew << e}
  end

  it "should override the previously stuck method" do
    Spearmint.stick_to String
    s = 'a string'
    s.chew.should == 'A STRING'
  end
end

describe "Composing behavior" do
  before :all do
    @original = Spearmint.chew.dup
    Spearmint.class_eval do
      stick :chew do
        self.gsub(/[a,e,i,o,u]/, '')
      end
    end
  end
  
  after :all do
    Spearmint.chew.clear
    @original.each {|e| Spearmint.chew << e}
  end

  it "should add to the previously defined behavior" do
    Spearmint.stick_to String
    s = 'a string'
    s.chew.should == 'gnrts '
  end
end

describe "Undefining stuck methods" do
  it "should not throw an error if we try do unstick something that's never been stuck" do
    Spearmint.stick_to String
    s = ''
    s.should_not respond_to(:bogus_method_name)
    Spearmint.unstick_from String => [:bogus_method_name], :ignore_errors => false
    s.should_not respond_to(:bogus_method_name)
  end
  
  it 'should be able to undefine methods that have been stuck to a class' do
    Spearmint.stick_to String
    s = ''
    s.should respond_to(:chew)
    s.should respond_to(:chew_it_up_and_spit_it_out)
    s.should respond_to(:open)
    validate_sticks_of_spearmint

    Spearmint.unstick_from String => [:chew], :ignore_errors => false
    s.should_not respond_to(:chew)
    s.should respond_to(:chew_it_up_and_spit_it_out)
    validate_sticks_of_spearmint

    Spearmint.unstick_from String => [:chew_it_up_and_spit_it_out], :ignore_errors => false
    s.should_not respond_to(:chew_it_up_and_spit_it_out)
    validate_sticks_of_spearmint
    
    Spearmint.unstick_from String => [:open], :ignore_errors => false
    s.should_not respond_to(:open)
    validate_sticks_of_spearmint
  end
  
  it 'should be able to undefine all stuck methods' do
    Spearmint.stick_to String
    s = 'jason'
    s.should respond_to(:chew)
    s.should respond_to(:chew_it_up_and_spit_it_out)
    s.should respond_to(:open)
    s.chew.should == 'nosaj'
    
    validate_sticks_of_spearmint

    Spearmint.unstick_all_from String, false
    s.should_not respond_to(:chew)
    s.should_not respond_to(:chew_it_up_and_spit_it_out)
    s.should_not respond_to(:open)

    validate_sticks_of_spearmint
  end
  
  def validate_sticks_of_spearmint
    Spearmint.chew.should_not be_empty
    Spearmint.chew_it_up_and_spit_it_out.should_not be_empty
    Spearmint.open.should_not be_empty
  end
end