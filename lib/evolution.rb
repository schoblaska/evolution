require 'rubygems'
require 'rvg/rvg'
require 'fileutils.rb'

require File.join(File.dirname(__FILE__), '/evolution/creature')
require File.join(File.dirname(__FILE__), '/evolution/polygon')
require File.join(File.dirname(__FILE__), '/evolution/simulation')
require File.join(File.dirname(__FILE__), '/evolution/class_ext')

include Magick


module Evolution
  
  # TODO: Load constants from config file
  CANVAS_SIZE = 200
  CANVAS_BACKGROUND = 'black'
  
  BASELINE_IMAGE_NAME = "baseline-200.gif"
  RENDER_DIRECTORY = File.join(File.dirname(__FILE__), "/../render")
  BASELINE_IMAGE_PATH = File.join(File.dirname(__FILE__), "/../baseline", BASELINE_IMAGE_NAME)
  BASELINE_IMAGE = Magick::Image.read(BASELINE_IMAGE_PATH)
  
  ADD_POLYGON_MUTATION_RATE = 4
  RGBA_MUTATION_RATE = 3
  POINT_MUTATION_RATE = 3
  ADD_POINT_MUTATION_RATE = 3
  
  
  def self.generate_mutation(var = {})
    min, max, initial = var[:min] || 0, var[:max] || 255, var[:initial]
    
    upwards = (((rand + 1) ** 10.0 / 1024) * (max - initial)).to_i
    downwards = (((rand + 1) ** 10.0 / 1024) * (initial - min)).to_i
    return (initial + upwards - downwards).restrict(:min => min, :max => max)
  end
  
end