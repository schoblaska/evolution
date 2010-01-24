module Evolution
  class Polygon
    
    attr_accessor :points, :red, :green, :blue, :alpha
    
    def initialize
      @points = []
      
      3.times do
        @points << [rand(Evolution::CANVAS_SIZE), rand(Evolution::CANVAS_SIZE)]
      end
      
      [:red=, :green=, :blue=, :alpha=].each do |attribute|
        send(attribute, rand(255))
      end
    end
    
  end
end