module Evolution
  class Creature
    
    attr_accessor :id, :polygons
    
    def initialize
      @id = Evolution::Creature.next_id
      @polygons = [Evolution::Polygon.new]
    end
    
    def mutate
      mutate_polygons
      add_polygon if rand(Evolution::ADD_POLYGON_MUTATION_RATE) == 0
    end
    
    def image_path
      File.join(render_directory, "#{"%09i" % id}.gif")
    end

    def svg_path
      File.join(render_directory, "#{"%09i" % id}.txt")
    end
    
    def spawn_child
      child = Evolution::Creature.new
      child.polygons = []
      polygons.each{ |polygon| child.polygons << polygon.dup }
      return child
    end
    
    def initialize_copy(other)
      super
    end
    
    
    protected
    
    def self.next_id
      @@next_id ||= 0
      @@next_id += 1
    end
    

    private
    
    def render_directory
      File.join(File.dirname(__FILE__), "/../../render")
    end
    
    def add_polygon
      @polygons << Evolution::Polygon.new
    end
    
    def mutate_polygons
      @polygons.each { |polygon| polygon.mutate }
    end
    
  end
end