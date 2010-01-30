require File.join(File.dirname(__FILE__), "/../test_helper")


class CreatureTest < Test::Unit::TestCase

  context 'initialization' do
    
    setup { @creature = Evolution::Creature.new }
    
    should 'initialize with one polygon' do
      @creature.polygons.size.should == 1
    end
    
    should 'increment id by 1 for each new instance' do
      @creature.id.should == 1
      Evolution::Creature.new.id.should == 2
    end
    
  end
  
  context 'mutating' do
    
    setup { @creature = Evolution::Creature.new }
    
    context 'adding a new polygon' do
      
      setup do
        mock(@creature).rand(Evolution::ADD_POLYGON_MUTATION_RATE) { 0 }
        mock.proxy(@creature).add_polygon
        @creature.mutate
      end
      
      should_change('the number of polygons', :by => 1) { @creature.polygons.size }
      
    end
    
    context 'mutating existing polygons' do
      
      setup do
        mock.proxy(@creature).mutate_polygons
      end
      
      should 'mutate all existing polygons' do
        @creature.polygons.each { |polygon| mock.proxy(polygon).mutate }
        @creature.mutate
      end
      
    end
        
  end
  
  context 'render and svg path' do
    
    setup do
      @creature = Evolution::Creature.new
      @creature.id = 1
    end
    
    should 'generate valid render path' do
      assert @creature.image_path.include?('render/000000001.gif')
    end
    
    should 'generate valid svg path' do
      assert @creature.svg_path.include?('render/000000001.txt')
    end
    
  end
  
  context 'spawning a child' do
    
    setup do
      stub.instance_of(Evolution::Creature).mutate { }
      @parent = Evolution::Creature.new
      @child = @parent.spawn_child
    end
    
    should 'increment id' do
      (@child.id - @parent.id).should == 1
    end
    
    should 'dup each polygon of parent' do
      @child.polygons.should_not == @parent.polygons
      
      @child.polygons.each_with_index do |child_polygon, i|
        parent_polygon = @parent.polygons[i]
        [:points, :red, :green, :blue, :alpha].each do |attribute|
          child_polygon.send(attribute).should == parent_polygon.send(attribute)
        end
      end
    end
    
  end
  
  context 'rendering svg and image' do
    
    setup do
      stub.instance_of(Evolution::Polygon).rand { 1 }
      @creature = Evolution::Creature.new
    end
        
    should 'convert to valid svg' do
      @creature.to_svg.should == "<svg width=\"800px\" height=\"800px\" viewBox=\"0 0 200 200\"xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">\n\t<rect x=\"0\" y=\"0\" width=\"200\" height=\"200\" fill=\"black\" />\t<polygon fill=\"#010101\" fill-opacity=\"0.00390625\" points=\"1,1 1,1 1,1\" /></svg>"
    end
    
    should 'create rmagick image' do
      mock.proxy(RVG).new(Evolution::CANVAS_SIZE, Evolution::CANVAS_SIZE)
      @creature.to_image
    end
    
    should 'convert to string' do
      @creature.to_s.should == "fitness: 57.23793 -- polygon count: 1"
    end
    
  end

end
