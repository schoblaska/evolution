require File.join(File.dirname(__FILE__), "/../test_helper")


class ClassExtTest < Test::Unit::TestCase

  context 'Numeric#restrict' do
    
    should 'restrict numbers below the minimum threshold' do
      number = 4.restrict(:min => 5)
      number.should == 5
    end
    
    should 'restrict numbers above the maximum threshold' do
      number = 4.restrict(:max => 3)
      number.should == 3
    end
    
  end
  
  context 'Numeric#to_hex' do
    
    should 'convert integers to hex strings' do
      200.to_hex.should == 'c8'
    end
    
  end

end