module Evolution
  class Polygon
    
    attr_accessor :points, :red, :green, :blue, :alpha
    
    def initialize
      @points = []
      3.times { add_point }
      [:red=, :green=, :blue=, :alpha=].each{ |method| send(method, rand(256)) }
    end
    
    def mutate
      mutate_rgba   if rand(Evolution::RGBA_MUTATION_RATE)       == 0
      mutate_points if rand(Evolution::POINT_MUTATION_RATE)      == 0
      add_point     if rand(Evolution::ADD_POINT_MUTATION_RATE)  == 0
    end
    
    
    private
    
    def mutate_rgba
      [:red, :green, :blue, :alpha].each do |attribute|
        mutated_value = Evolution.generate_mutation(:min => 0, :max => 255, :initial => send(attribute))
        send("#{attribute}=", mutated_value)
      end
    end
    
    def mutate_points
      points.each_with_index do |point, i|
        mutated_values = point.map { |value| Evolution.generate_mutation(:max => Evolution::CANVAS_SIZE, :initial => value) }
        points[i] = mutated_values
      end
    end
    
    def add_point
      @points << [rand(Evolution::CANVAS_SIZE), rand(Evolution::CANVAS_SIZE)]
    end
    
  end
end