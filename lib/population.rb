module GeneticAlgorithm
  # Idempotent conversion method. Coerces various inputs to a Population.
  # Use to flexibly ensure you have a usable Population object.
  def Population(*args)
    case args.first
    when Population then args.first
    when Array      then Population.new(args.first.map { |c| Chromosome(c) })
    when Integer    then Population.new(Array.new(args.first) { Chromosome.new })
    else
      raise TypeError, "Cannot covert #{args.inspect} to Population"
    end
  end

  class Population
    attr_reader :chromosomes

    def initialize(chromosomes=Chromosome.generate(100))
      @chromosomes = chromosomes
    end

    def fittest
      Chromosome.new
    end

    def average_fitness
      rand
    end

    def size
      chromosomes.length
    end
  end
end

