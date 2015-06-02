module GeneticAlgorithm
  class Simulation
    attr_accessor :population, :analysis

    def initialize(options={})
      @population         = Population.new(options[:chromosomes])
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
      new_population = Population([])
      half_population_size = config[:population_size] / 2
      half_population_size.times do
        chromosomes = select_chromosomes
        chromosomes = chromosomes.first.maybe_crossover!(chromosomes.last, analysis)
        chromosomes.each { |c| new_population << c.maybe_mutate!(analysis) }
      end
      analysis[:generations] += 1
      @population = new_population
    end

    def select_chromosomes
      selection_map = config[:selection_strategy].create_map(config[:ideal_phenotype], population)
      2.times.map { config[:selection_strategy].sample(selection_map) }
    end
  end
end
