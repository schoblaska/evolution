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
  
  context 'mutation' do
    
    setup { @polygon = Evolution::Polygon.new }
    
    context 'mutating rgba values' do
      
      setup do
        stub(@polygon).rand(Evolution::RGBA_MUTATION_RATE).any_number_of_times { 0 }
        stub(@polygon).rand { 1 }
        stub(Evolution).generate_mutation { 99 }
      end
      
      should 'mutate rgba values for polygon' do
        mock.proxy(@polygon).mutate_rgba
         
        @polygon.mutate
        
        [:red, :green, :blue, :alpha].each do |attribute|
          @polygon.send(attribute).should == 99
        end
      end
      
    end
    
    context 'mutating points' do
      
      setup do
        stub(@polygon).rand(Evolution::POINT_MUTATION_RATE).any_number_of_times { 0 }
        stub(@polygon).rand { 1 }
        stub(Evolution).generate_mutation { 99 }
        stub(@polygon).add_point { }
      end
      
      should 'mutate all points on the polygon' do        
        mock.proxy(@polygon).mutate_points
        @polygon.mutate
        @polygon.points.each { |point| point.should == [99, 99] }
      end
      
    end
    
    context 'adding a new point' do
      
      should 'add a new point to the polygon' do        
        mock(@polygon).rand(Evolution::ADD_POINT_MUTATION_RATE).any_number_of_times { 0 }
        stub(@polygon).rand { 1 }
        mock.proxy(@polygon).add_point

        @polygon.mutate
      end
      
    end
    
    context 'svg and rmagick strings' do
      
      setup do
        stub.instance_of(Evolution::Polygon).rand { 1 }
        @polygon = Evolution::Polygon.new
      end
      
      should 'convert polygon points and rgba to valid svg string' do
        @polygon.to_svg.should == "\t<polygon fill=\"#010101\" fill-opacity=\"0.00390625\" points=\"1,1 1,1 1,1\" />"
      end
      
      should 'convert polygon rgba values to valid fill string for rmagick' do
        @polygon.fill_string.should == '#01010101'
      end
      
    end
    
  end

end