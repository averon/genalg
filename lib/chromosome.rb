module GeneticAlgorithm
  class Chromosome
    def fitness
      rand
    end

    def +(other)
      [Chromosome.new, Chromosome.new]
    end

    def maybe_mutate!
    end
  end
end
