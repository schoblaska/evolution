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
  NEW_POLYGON_MUTATION_RATE = 10
  
  def self.mutation_strength(max)
    (((rand + 1) ** 8.0 / 256) * max).to_i.restrict(:min => 1, :max => max)
  end
  
end