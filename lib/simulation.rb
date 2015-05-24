module GeneticAlgorithm
  class Simulation
    attr_accessor :config, :population

    def initialize(config, population=Population.new)
      @config = config
      @population = population
    end

    def run
      config[:num_generations].times { next_generation }
      ::Chromosome.new
    end

    def next_generation
    end
  end
end
