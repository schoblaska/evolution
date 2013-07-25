require 'rubygems'
require 'bundler'

Bundler.require

Dir["./lib/evolution/*.rb"].each{|file| require file }

include Magick


module Evolution
  def self.generate_mutation(var = {})
    min, max, initial = var[:min] || 0, var[:max] || 255, var[:initial]

    upwards = (((rand + 1) ** 12.0 / 4096) * (max - initial)).to_i
    downwards = (((rand + 1) ** 12.0 / 4096) * (initial - min)).to_i
    return (initial + upwards - downwards).restrict(:min => min, :max => max)
  end
end
