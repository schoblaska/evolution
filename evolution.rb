require 'rubygems'
require 'rvg/rvg'
require 'fileutils.rb'
include Magick

RENDER_PATH = "/Users/username/Desktop/evolution"
BASELINE_IMAGE_PATH = "/Users/username/Desktop/evolution/baseline-200.gif"
BASELINE_IMAGE = Magick::Image.read(BASELINE_IMAGE_PATH)
CANVAS_SIZE = 200 # square which should match baseline image size
CANVAS_BACKGROUND = "black"
ALPHA_MIN = 24
ALPHA_MAX = 164

# mutation rates (higher number = higher liklihood)
ADD_POLYGON_MUTATION_RATE = 3
ADD_POINT_MUTATION_RATE = 5
MOD_RGBA_MUTATION_RATE = 50
MOD_POINT_MUTATION_RATE = 50

# mutation strengths
MOD_RGBA_MUTATION_STRENGTH = 10 # maximum number (out of 255) of points to move in either direction
MOD_POINT_MUTATION_STRENGTH = 5 # maximum percentage of total canvas size to move along either axis

$id = 0
$bump = 0

class Numeric
  def restrict(min = 0, max = 255)
    self < min ? min : (self > max ? max : self)
  end

  def to_hex
    to_s(base=16).rjust(2, '0')
  end
end

class Array
  
  def random(weights = nil)
    return random(map {|n| n.send(weights)}) if weights.is_a? Symbol

    weights ||= Array.new(length, 1.0)
    total = weights.inject(0.0) {|t,w| t+w}
    point = rand * total

    zip(weights).each do |n,w|
      return n if w >= point
      point -= w
    end
  end
  
end

class Creature
  
  attr_accessor :creature_id, :fitness, :image, :image_path, :svg_path, :polygons
  
  def initialize
    @creature_id = next_id
  end
  
  def image
    @image ||= RVG.new(CANVAS_SIZE, CANVAS_SIZE).viewbox(0,0,CANVAS_SIZE,CANVAS_SIZE){ |canvas|
                 canvas.background_fill = CANVAS_BACKGROUND
                 polygons.each{ |polygon| canvas.polygon(polygon[:points].flatten).styles(:fill=> generate_fill_string(polygon)) }
               }.draw
  end
  
  def save
    @image.write(image_path)
    create_svg_file
  end

  def fitness
    @fitness ||= image.difference(BASELINE_IMAGE[0])[0]
  end
  
  def image_path
    @image_path ||= "#{RENDER_PATH}/#{"%09i" % creature_id}.gif" 
  end
  
  def svg_path
    @svg_path ||= "#{RENDER_PATH}/#{"%09i" % creature_id}.txt" 
  end
  
  def random_polygon
    polygons[rand(polygons.size)]
  end
  
  def create_svg_file
    File.open(svg_path, 'w') do |file|  
      file.puts "<svg width=\"#{CANVAS_SIZE}px\" height=\"#{CANVAS_SIZE}px\" viewBox=\"0 0 #{CANVAS_SIZE} #{CANVAS_SIZE}\" xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">\n"
      file.puts "\t<rect x=\"0\" y=\"0\" width=\"#{CANVAS_SIZE}\" height=\"#{CANVAS_SIZE}\" fill=\"#{CANVAS_BACKGROUND}\" />"
      
      polygons.each do |polygon|
        fill = generate_fill_string(polygon, false)
        fill_opacity = polygon[:alpha] / 256.0
        points = polygon[:points].map{|a| a.join(',')}.join(' ')
        file.puts "\t<polygon fill=\"#{fill}\" fill-opacity=\"#{fill_opacity}\" points=\"#{points}\" />"
      end
      
      file.puts "</svg>"
    end
  end
  
end

def next_id
  $id += 1
end

def spawn_mutated_child(parent)
  child = Creature.new
  child.polygons = eval(parent.polygons.inspect)

  case ["add polygon", "add point", "mod rgba", "mod point"].random([ADD_POLYGON_MUTATION_RATE, ADD_POINT_MUTATION_RATE, MOD_RGBA_MUTATION_RATE, MOD_POINT_MUTATION_RATE])
  when "add polygon"
    child.polygons << random_new_polygon
  when "add point"
    polygon = child.random_polygon
    polygon[:points].insert(rand(polygon[:points].size), [rand(CANVAS_SIZE), rand(CANVAS_SIZE)])
  when "mod rgba"
    polygon = child.random_polygon
    [:red, :green, :blue].each{ |sym| polygon[sym] = mutate_hex(polygon[sym]) }
    polygon[:alpha] = mutate_hex(polygon[:alpha], :min => ALPHA_MIN, :max => ALPHA_MAX)
  when "mod point"
    polygon = child.random_polygon
    polygon[:points].each_with_index{ |points,i| polygon[:points][i] = mutate_points(points) }
  end

  return child
end

def generate_fill_string(polygon, alpha = true)
  string = "#" + polygon[:red].to_hex + polygon[:green].to_hex + polygon[:blue].to_hex
  string << polygon[:alpha].to_hex if alpha
  return string
end

def random_new_polygon
  points = []
  hexes = []
  point_offset_x = rand(CANVAS_SIZE)
  point_offset_y = rand(CANVAS_SIZE)
  
  3.times do
    points << (point_offset_x + rand(CANVAS_SIZE / 10)).restrict(0, CANVAS_SIZE)
    points << (point_offset_y + rand(CANVAS_SIZE / 10)).restrict(0, CANVAS_SIZE)
  end

  4.times { hexes << rand(256) }

  {:points => [[points.pop,points.pop], [points.pop,points.pop], [points.pop,points.pop]], :red => hexes.pop, :green => hexes.pop, :blue => hexes.pop, :alpha => hexes.pop}
end

def mutate_points(points)
  x = (points[0] + rand(CANVAS_SIZE * MOD_POINT_MUTATION_STRENGTH * 0.02) - (CANVAS_SIZE * MOD_POINT_MUTATION_STRENGTH * 0.01)).restrict(0, CANVAS_SIZE)
  y = (points[1] + rand(CANVAS_SIZE * MOD_POINT_MUTATION_STRENGTH * 0.02) - (CANVAS_SIZE * MOD_POINT_MUTATION_STRENGTH * 0.01)).restrict(0, CANVAS_SIZE)
    
  return [x, y]
end

def mutate_hex(hex, var = {})
  var[:min] ||= 0
  var[:max] ||= 255
  
  return (hex + rand(MOD_RGBA_MUTATION_STRENGTH * 2) - MOD_RGBA_MUTATION_STRENGTH).restrict(var[:min], var[:max])
end

@most_fit = Creature.new
@most_fit.polygons = [random_new_polygon]

while $id < 1000000
  child = spawn_mutated_child(@most_fit)
  
  if child.fitness < @most_fit.fitness
    child.save if ($bump += 1) % 50 == 0
    puts "fitness: #{child.fitness.to_s[0..7]} -- polygon count: #{child.polygons.size.to_s}"
    @most_fit = child
  end
end