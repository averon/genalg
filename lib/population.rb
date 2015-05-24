module GeneticAlgorithm
  class Population
    def fittest
      ::Chromosome.new
    end

    def average_fitness
      rand
    end
  end
end

