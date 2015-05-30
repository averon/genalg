require 'bigdecimal'

files_to_require = Dir[
  File.expand_path('lib/**.rb'),
  File.expand_path('lib/**/**.rb')
]

files_to_require.each { |file| require file }

include GeneticAlgorithm
