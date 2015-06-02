require 'bigdecimal'

files_to_require = Dir[
  File.expand_path('lib/**.rb'),
  File.expand_path('lib/**/**.rb')
]

files_to_require.each { |file| require file }

include GeneticAlgorithm

SELECTION_STRATEGY = SelectionStrategy::IntegerCodexInfixEvaluation.new
ANALYSIS = {
    generations: 0,
    mutations: {
      chances: 0,
      occurences: 0,
    },
    crossovers: {
      chances: 0,
      occurences: 0,
    },
    solutions: 0
  }

def config
  {
    crossover_rate: 0.7,
    mutation_rate: 0.002,
    num_generations: 10,
    num_simulations: 1,
    population_size: 100,
    chromosome_size:  28,
    ideal_phenotype: 27,
    selection_strategy: SELECTION_STRATEGY
  }
end


