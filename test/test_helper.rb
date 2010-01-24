$: << File.join(File.dirname(__FILE__), *"/../lib")

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'matchy'
require 'rr'

require 'evolution'

class Test::Unit::TestCase
  
  include RR::Adapters::TestUnit
  
end