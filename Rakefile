require './lib/evolution'

task :run do
  baseline_image_path = ENV['baseline_image'] ? ENV['baseline_image'] : './images/baseline.jpg'
  baseline_image = Magick::Image.read(baseline_image_path)[0]

  CONFIG = {
    :canvas_background => ENV['canvas_background'] || 'white',
    :render_directory => File.join(File.dirname(__FILE__), "./images/renders"),
    :baseline_image => baseline_image,
    :canvas_width => baseline_image.columns,
    :canvas_height => baseline_image.rows,
    :add_polygon_mutation_rate => ENV['add_polygon_mutation_rate'] ? ENV['add_polygon_mutation_rate'].to_i : 100,
    :rgba_mutation_rate => ENV['rgba_mutation_rate'] ? ENV['rgba_mutation_rate'].to_i : 20,
    :point_mutation_rate => ENV['point_mutation_rate'] ? ENV['point_mutation_rate'].to_i : 20,
    :add_point_mutation_rate => ENV['add_point_mutation_rate'] ? ENV['add_point_mutation_rate'].to_i : 200,
    :fitness_target => ENV['fitness_target'] ? ENV['fitness_target'].to_i : 500,
    :write_frequency => ENV['write_frequency'] ? ENV['write_frequency'].to_i : 50
  }

  most_fit = Evolution::Candidate.new
  write = 0

  while most_fit.fitness > CONFIG[:fitness_target]
    child = most_fit.spawn_child

    if child.fitness < most_fit.fitness
      write += 1
      child.save if write % CONFIG[:write_frequency] == 0
      puts child.to_s
      most_fit = child
    end
  end
end
