require './lib/evolution'

task :run do
  config = {
    :canvas_background => ENV['canvas_background'] || 'black',
    :render_directory => File.join(File.dirname(__FILE__), "./images/renders"),
    :baseline_image => ENV['baseline_image'] || Magick::Image.read('./images/baseline.png')[0],
    :add_polygon_mutation_rate => ENV['add_polygon_mutation_rate'] ? ENV['add_polygon_mutation_rate'].to_i : 100,
    :rgba_mutation_rate => ENV['rgba_mutation_rate'] ? ENV['rgba_mutation_rate'].to_i : 20,
    :point_mutation_rate => ENV['point_mutation_rate'] ? ENV['point_mutation_rate'].to_i : 20,
    :add_point_mutation_rate => ENV['add_point_mutation_rate'] ? ENV['add_point_mutation_rate'].to_i : 200
  }

  config[:canvas_width] = config[:baseline_image].bounding_box.width
  config[:canvas_height] = config[:baseline_image].bounding_box.height

  CONFIG = config

  most_fit = Evolution::Candidate.new
  write = 0

  while most_fit.fitness > 10
    child = most_fit.spawn_child

    if child.fitness < most_fit.fitness
      write += 1
      child.save if write % 50 == 0
      puts child.to_s
      most_fit = child
    end
  end
end
