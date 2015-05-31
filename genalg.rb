require 'bigdecimal'

files_to_require = Dir[
  File.expand_path('lib/**.rb'),
  File.expand_path('lib/**/**.rb')
]

files_to_require.each { |file| require file }

def config
  {
    crossover_rate: 0.7,
    mutation_rate: 0.002,
    num_generations: 100,
    num_simulations: 10,
    population_size: 100,
    chromosome_size: 16,
    ideal_phenotype: 27,
  }
end

include GeneticAlgorithm

