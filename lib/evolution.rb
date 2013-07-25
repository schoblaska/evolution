require 'rubygems'
require 'bundler'

Bundler.require

Dir["./lib/evolution/*.rb"].each{|file| require file }

include Magick

module Evolution
end
