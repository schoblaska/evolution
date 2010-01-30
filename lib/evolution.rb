require 'rubygems'
require 'rvg/rvg'
require 'fileutils.rb'

require 'evolution/creature'
require 'evolution/polygon'
require 'evolution/simulation'
require 'evolution/class_ext'

include Magick


module Evolution
  
  # TODO: Load constants from config file
  CANVAS_SIZE = 200
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