require 'rubygems'
require 'rvg/rvg'
require 'fileutils.rb'
include Magick

RENDER_PATH = "/Users/username/evolution"
BASELINE_IMAGE_PATH = "/Users/username/evolution/baseline-200.gif"
BASELINE_IMAGE = Magick::Image.read(BASELINE_IMAGE_PATH)
CANVAS_SIZE = 200 # square which should match baseline image size
CANVAS_BACKGROUND = "black"
MAX_POLYGONS = 100
MAX_POLYGON_COMPLEXITY = 10
ALPHA_MIN = 24
ALPHA_MAX = 164

# mutation rates (generations per mutation)
ADD_POLYGON_MUTATION_RATE = 750
ADD_POINT_MUTATION_RATE = 1500
MOD_RGBA_MUTATION_RATE = 1500
MOD_POINT_MUTATION_RATE = 1500

# mutation strengths
MOD_RGBA_MUTATION_STRENGTH = 10 # maximum number (out of 255) of points to move in either direction
MOD_POINT_MUTATION_STRENGTH = 5 # maximum percentage of total canvas size to move along either axis

$id = 0

class Creature
  
  attr_accessor :creature_id, :fitness, :image, :image_path, :polygons, :created_at
  
  def render
    rvg = RVG.new(CANVAS_SIZE, CANVAS_SIZE).viewbox(0,0,CANVAS_SIZE,CANVAS_SIZE) do |canvas|
      canvas.background_fill = CANVAS_BACKGROUND
      self.polygons.each{ |polygon| canvas.polygon(polygon[:points].flatten).styles(:fill=> generate_fill_string(polygon)) }
    end
    
    rvg.draw.write(self.image_path)
  end
  
  def fitness
    @fitness || @fitness = self.image[0].difference(BASELINE_IMAGE[0])[0]
  end
  
  def image_path
    @image_path || @image_path = "#{RENDER_PATH}/#{self.creature_id}.gif"
  end
  
  def image
    @image || @image = Magick::Image.read(self.image_path)
  end
  
  def remove_image
    FileUtils.rm(self.image_path, :force => true)
  end
  
end

def next_id
  $id += 1
end

def spawn_mutated_child(parent)
  child = Creature.new
  child.created_at = Time.now
  child.creature_id = next_id
  child.polygons = eval(parent.polygons.inspect)
  original_polygons = eval(parent.polygons.inspect)

  while child.polygons.inspect == original_polygons.inspect do
    # mutate
    child.polygons.each do |polygon|
      # add point
      polygon[:points] << [rand(CANVAS_SIZE), rand(CANVAS_SIZE)] if rand(ADD_POINT_MUTATION_RATE) == 0and polygon[:points].size < MAX_POLYGON_COMPLEXITY
    
      # mod points
      polygon[:points].each_with_index{ |points,i| polygon[:points][i] = mutate_points(points) if rand(MOD_POINT_MUTATION_RATE) == 0 }
    
      # mod RGB
      [:red, :green, :blue].each{ |sym| polygon[sym] = mutate_hex(polygon[sym]) if rand(MOD_RGBA_MUTATION_RATE) == 0 }
      
      # mod alpha
      polygon[:alpha] = mutate_hex(polygon[:alpha], :min => ALPHA_MIN, :max => ALPHA_MAX) if rand(MOD_RGBA_MUTATION_RATE) == 0
    end
    
    # add random polygon
    child.polygons << random_polygon if rand(ADD_POLYGON_MUTATION_RATE) == 0 and child.polygons.size < MAX_POLYGONS
  end

  return child
end

def generate_fill_string(polygon)
  "#" + to_hex(polygon[:red]) + to_hex(polygon[:green]) + to_hex(polygon[:blue]) + to_hex(polygon[:alpha])
end

def to_hex(integer)
  integer.to_s(base=16).rjust(2, '0')
end

def create_first_creature
  creature = Creature.new
  creature.created_at = Time.now
  creature.creature_id = next_id
  creature.polygons = [random_polygon]
  return creature
end

def random_polygon
  points = []
  hexes = []
  point_offset_x = rand(CANVAS_SIZE)
  point_offset_y = rand(CANVAS_SIZE)
  
  3.times do
    x = point_offset_x + rand(CANVAS_SIZE / 5)
    x = 0 if x < 0
    x = CANVAS_SIZE if x > CANVAS_SIZE
    points << x
    
    y = point_offset_y + rand(CANVAS_SIZE / 5)
    y = 0 if y < 0
    y = CANVAS_SIZE if y > CANVAS_SIZE
    points << y
  end

  3.times { hexes << rand(256) }
  hexes << rand(ALPHA_MAX - ALPHA_MIN) + ALPHA_MIN

  {:points => [[points.pop,points.pop], [points.pop,points.pop], [points.pop,points.pop]], :red => hexes.pop, :green => hexes.pop, :blue => hexes.pop, :alpha => hexes.pop}
end

def mutate_points(points)
  x = points[0] + rand(CANVAS_SIZE * MOD_POINT_MUTATION_STRENGTH * 0.02) - (CANVAS_SIZE * MOD_POINT_MUTATION_STRENGTH * 0.01)
  x = 0 if x < 0
  x = CANVAS_SIZE if x > CANVAS_SIZE
  
  y = points[1] + rand(CANVAS_SIZE * MOD_POINT_MUTATION_STRENGTH * 0.02) - (CANVAS_SIZE * MOD_POINT_MUTATION_STRENGTH * 0.01)
  y = 0 if y < 0
  y = CANVAS_SIZE if y > CANVAS_SIZE
    
  return [x, y]
end

def mutate_hex(hex, var = {})
  var[:min] ||= 0
  var[:max] ||= 255
  
  hex = hex + rand(MOD_RGBA_MUTATION_STRENGTH * 2) - MOD_RGBA_MUTATION_STRENGTH
  hex = var[:min] if hex < var[:min]
  hex = var[:max] if hex > var[:max]
  return hex
end

@most_fit = create_first_creature
@most_fit.render

while $id < 1000000
  child = spawn_mutated_child(@most_fit)
  child.render
  if child.fitness < @most_fit.fitness
    @most_fit.remove_image unless @most_fit.creature_id % 20 == 0 # save a few images
    puts "fitness: #{child.fitness.to_s[0..7]} -- polygon count: #{child.polygons.size.to_s}"
    @most_fit = child
  else
    child.remove_image
  end
end