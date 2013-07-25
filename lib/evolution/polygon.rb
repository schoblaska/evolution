module Evolution
  class Polygon
    attr_accessor :points, :red, :green, :blue, :alpha

    def self.calculate_mutation(var = {})
      min, max, initial = var[:min] || 0, var[:max] || 255, var[:initial]

      upwards = (((rand + 1) ** 12.0 / 4096) * (max - initial)).to_i
      downwards = (((rand + 1) ** 12.0 / 4096) * (initial - min)).to_i
      return (initial + upwards - downwards).restrict(:min => min, :max => max)
    end

    def initialize(other = nil)
      @points = []

      if other
        other.points.each{|point| self.points << point}
        [:red, :green, :blue, :alpha].each{|method| send("#{method}=", other.send(method))}
      else
        3.times { add_point }
        [:red=, :green=, :blue=, :alpha=].each{|method| send(method, rand(256))}
      end
    end

    def mutate
      mutate_rgba   if rand(CONFIG[:rgba_mutation_rate])      == 0
      mutate_points if rand(CONFIG[:point_mutation_rate])     == 0
      add_point     if rand(CONFIG[:add_point_mutation_rate]) == 0
    end

    def to_svg
      fill = "#" + red.to_hex + green.to_hex + blue.to_hex
      fill_opacity = alpha / 256.0
      points_string = points.map{|point| point.join(',')}.join(' ')
      "<polygon fill=\"#{fill}\" fill-opacity=\"#{fill_opacity}\" points=\"#{points_string}\" />"
    end

    def fill_string
      "#" + red.to_hex + green.to_hex + blue.to_hex + alpha.to_hex
    end

    private

    def mutate_rgba
      [:red, :green, :blue, :alpha].each do |attribute|
        mutated_value = Polygon.calculate_mutation(:min => 0, :max => 255, :initial => send(attribute))
        send("#{attribute}=", mutated_value)
      end
    end

    def mutate_points
      self.points = points.map do |point|
        [
          Polygon.calculate_mutation(:max => CONFIG[:canvas_width] - 1, :initial => point[0]),
          Polygon.calculate_mutation(:max => CONFIG[:canvas_height] - 1, :initial => point[1])
        ]
      end
    end

    def add_point
      if points.empty?
        @points << [rand(CONFIG[:canvas_width]), rand(CONFIG[:canvas_height])]
      elsif points.size == 1
        x = Polygon.calculate_mutation(:initial => points[0][0], :min => 0, :max => CONFIG[:canvas_width] - 1)
        y = Polygon.calculate_mutation(:initial => points[0][1], :min => 0, :max => CONFIG[:canvas_height] - 1)
        @points << [x, y]
      else
        point_a = points[rand(points.size)]
        index = points.index(point_a)
        point_b = points[(index + 1) % points.size]
        x = Polygon.calculate_mutation(:initial => (point_a[0] + point_b[0]) / 2, :min => 0, :max => CONFIG[:canvas_width] - 1)
        y = Polygon.calculate_mutation(:initial => (point_a[1] + point_b[1]) / 2, :min => 0, :max => CONFIG[:canvas_height] - 1)
        @points.insert(index + 1, [x, y])
      end
    end
  end
end
