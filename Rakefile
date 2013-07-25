require './lib/evolution'

task :run do
  @most_fit = Evolution::Candidate.new

  while @most_fit.fitness > 10
    child = @most_fit.spawn_child
    write = 0

    if child.fitness < @most_fit.fitness
      write += 1
      child.save if write % 50 == 0
      puts child.to_s
      @most_fit = child
    end
  end
end
