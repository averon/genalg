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
    include Enumerable

    def initialize(chromosomes=nil)
      @chromosomes = chromosomes || Chromosome.generate(config[:population_size])
    end

    def fittest
      fittest = chromosomes.max_by { |c| config[:selection_strategy].evaluate(c) }
      ANALYSIS[:solutions] += 1 if fittest.fitness == 2.0
      fittest
    end

    def average_fitness
      BigDecimal("#{total_fitness / size}")
    end

    def total_fitness
      chromosomes.inject(0) { |sum, c| sum + config[:selection_strategy].evaluate(c) }
    end

    def size
      chromosomes.length
    end

    def <<(chromosome)
      chromosomes << Chromosome(chromosome)
    end

    def each(*args, &block)
      chromosomes.each(*args, &block)
    end

    def to_a
      chromosomes
    end

    protected

    attr_reader :chromosomes
  end
end

