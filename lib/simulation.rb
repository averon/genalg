module GeneticAlgorithm
  class Simulation
    attr_accessor :config, :population, :selection_strategy

    def initialize(config, options={})
      @config = config
      @population         = Population(options[:population] || config[:population_size])
      @selection_strategy = options[:selection_strategy] || SelectionStrategy::RouletteWheel.new
    end

    def run
      config[:num_generations].times { next_generation }
      Chromosome.new
    end

    def next_generation
      half_population_size = config[:population_size] / 2
      selected_pairs = half_population_size.times.map do
        chromosomes = select_chromosomes
        chromosomes = chromosomes.first + chromosomes.last
        chromosomes.map { |c| c.maybe_mutate!(config[:mutation_rate]) }
      end
      @population = Population(selected_pairs.flatten)
    end

    def select_chromosomes
      selection_map = selection_strategy.create_map(config, population)
      2.times.map { selection_strategy.sample(selection_map) }
    end
  end
end
