module GeneticAlgorithm
  class Simulation
    attr_accessor :config, :population, :selection_strategy

    def initialize(config,
                   population=Population.new,
                   selection_strategy=SelectionStrategy::RouletteWheel.new)

      @config = config
      @population = population
      @selection_strategy = selection_strategy
    end

    def run
      config[:num_generations].times { next_generation }
      ::Chromosome.new
    end

    def next_generation
      half_population_size = config[:population_size] / 2

      half_population_size.times.map do
        chromosomes = select_chromosomes
        chromosomes = chromosomes.first + chromosomes.last
        chromosomes.map { |c| c.maybe_mutate! }
      end.flatten
    end

    def select_chromosomes
      selection_map = selection_strategy.create_map(config, population)
      2.times.map   { selection_strategy.sample(selection_map) }
    end
  end
end
