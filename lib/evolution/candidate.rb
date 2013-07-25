require 'rvg/rvg'

module Evolution
  class Candidate
    attr_accessor :id, :polygons

    def initialize
      @id = Evolution::Candidate.next_id
      @polygons = [Evolution::Polygon.new]
    end

    def fitness
      @fitness ||= to_image.difference(Evolution::BASELINE_IMAGE[0])[0]
    end

    def mutate
      mutate_polygons
      add_polygon if rand(Evolution::ADD_POLYGON_MUTATION_RATE) == 0
    end

    def image_path
      File.join(Evolution::RENDER_DIRECTORY, "#{"%09i" % id}.gif")
    end

    def svg_path
      File.join(Evolution::RENDER_DIRECTORY, "#{"%09i" % id}.txt")
    end

    def spawn_child
      child = Evolution::Candidate.new
      child.polygons = []
      polygons.each{ |polygon| child.polygons << Evolution::Polygon.new(polygon) }
      child.mutate
      return child
    end

    def to_svg
      string = "<svg width=\"800px\" height=\"800px\" viewBox=\"0 0 #{Evolution::CANVAS_SIZE} #{Evolution::CANVAS_SIZE}\"xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">\n  <rect x=\"0\" y=\"0\" width=\"#{Evolution::CANVAS_SIZE}\" height=\"#{Evolution::CANVAS_SIZE}\" fill=\"#{Evolution::CANVAS_BACKGROUND}\" />\n"
      string << polygons.map{|polygon| "  #{polygon.to_svg}"}.join("\n")
      string << "\n</svg>"
    end

    def to_image
      return @image if @image

      @image = RVG.new(Evolution::CANVAS_SIZE, Evolution::CANVAS_SIZE)
      @image.viewbox(0, 0, Evolution::CANVAS_SIZE, Evolution::CANVAS_SIZE){ |canvas|
        canvas.background_fill = Evolution::CANVAS_BACKGROUND
        polygons.each{ |polygon| canvas.polygon(polygon.points.flatten).styles(:fill=> polygon.fill_string) }
      }.draw
    end

    def to_s
      "#{"%09i" % id} fitness: #{fitness.to_s[0..7]} -- polygon count: #{polygons.size.to_s}"
    end

    def save
      File.open(svg_path, 'w') { |file| file.puts(to_svg) }
      to_image.draw.write(image_path)
    rescue => e
      binding.pry
    end

    protected

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
