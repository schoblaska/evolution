require File.join(File.dirname(__FILE__), "/../test_helper")


class PolygonTest < Test::Unit::TestCase

  context 'initialization' do
    
    setup { @polygon = Evolution::Polygon.new }
    
    should 'create three random points' do
      @polygon.points.size.should == 3
      @polygon.points.each do |point|
        point.size.should == 2
        point.each do |coordinate|
          assert coordinate < Evolution::CANVAS_SIZE
          assert coordinate >= 0
        end
      end
    end
    
    should 'initialize integer values for red, green, blue and alpha' do
      [:red, :blue, :green, :alpha].each do |attribute|
        assert @polygon.send(attribute) >= 0 and @polygon.send(attribute) < 256
      end
    end
    
  end

end