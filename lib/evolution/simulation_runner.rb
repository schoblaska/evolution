module Evolution
  class SimulationRunner
    
    def self.run
      @most_fit = Evolution::Creature.new
      
      while @most_fit.fitness > 10
        child = @most_fit.spawn_child

        if child.fitness < @most_fit.fitness
          child.save if Evolution::SimulationRunner.bump % 50 == 0
          puts child.to_s
          @most_fit = child
        end
      end
    end
    
    def self.bump
      @@bump = 0
      @@bump += 1
    end

  end
end