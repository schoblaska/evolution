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
    
    def self.next_id
      @@next_id ||= 0
      @@next_id += 1
    end
    
    
    private
    
    def add_polygon
      @polygons << Evolution::Polygon.new
    end
    
    def mutate_polygons
      @polygons.each { |polygon| polygon.mutate }
    end
    
  end
end