module Evolution
  class Creature
    
    attr_accessor :id, :polygons
    
    def initialize
      @id = Evolution::Creature.next_id
      @polygons = [Evolution::Polygon.new]
    end
    
    def mutate
      rand(Evolution::NEW_POLYGON_MUTATION_RATE) == 0 ? add_polygon : mutate_polygon
    end
    
    def self.next_id
      @@next_id ||= 0
      @@next_id += 1
    end
    
    
    private
    
    def add_polygon
      @polygons << Evolution::Polygon.new
    end
    
    def mutate_polygon
      @polygons[rand(@polygons.size)].mutate
    end
    
  end
end