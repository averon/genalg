module GeneticAlgorithm
  class Simulation
    attr_accessor :config, :population, :selection_strategy, :analysis

    def initialize(config, options={})
      @config = config
      @population         = Population(options[:population] || config[:population_size])
      @selection_strategy = options[:selection_strategy] || SelectionStrategy::RouletteWheel.new
      @analysis = {
        generations: 0,
        mutations: {
          chances: 0,
          occurences: 0,
        },
        crossovers: {
          chances: 0,
          occurences: 0,
        },
      }
    end

    def run
      config[:num_generations].times { next_generation }
      population.fittest
    end

    def next_generation
      half_population_size = config[:population_size] / 2
      selected_pairs = half_population_size.times.map do
        chromosomes = select_chromosomes
        chromosomes = chromosomes.first.maybe_crossover!(chromosomes.last, config[:crossover_rate], analysis)
        chromosomes.map { |c| c.maybe_mutate!(config[:mutation_rate], analysis) }
      end
      analysis[:generations] += 1
      @population = Population(selected_pairs.flatten)
    end

    def select_chromosomes
      selection_map = selection_strategy.create_map(population)
      2.times.map { selection_strategy.sample(selection_map) }
    end
  end
end
