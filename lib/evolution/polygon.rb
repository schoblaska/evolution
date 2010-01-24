module Evolution
  class Polygon
    
    attr_accessor :points, :red, :green, :blue, :alpha
    
    def initialize
      @points = []
      3.times { @points << [rand(Evolution::CANVAS_SIZE), rand(Evolution::CANVAS_SIZE)] }
      [:red=, :green=, :blue=, :alpha=].each{ |method| send(method, rand(256)) }
    end
    
    def mutate
      
    end
    
  end
end