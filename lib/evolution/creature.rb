module Evolution
  class Creature
    
    attr_accessor :id, :polygons
    
    def initialize(var = {})
      @id = var[:id]
      @polygons = var[:polygons]
    end
    
  end
end