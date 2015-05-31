module GeneticAlgorithm
  # Idempotent conversion method. Coerces various inputs to a Chromosome.
  # Use to flexibly ensure you have a usable Chromosome object.
  def Chromosome(*args)
    case args.first
    when Chromosome then args.first
    when Integer    then Chromosome.new(args.first.to_s(2))
    when String     then Chromosome.new(args.first)
    else
      raise TypeError, "Cannot convert #{args.inspect} to Chromosome"
    end
  end

  class Chromosome
    attr_reader :bin_str

    def self.generate(n=1)
      Array.new(n) { Chromosome.new }
    end

    def initialize(bin_str=rand(32).to_s(2))
      @bin_str = bin_str
    end

    def fitness
      rand
    end

    def +(other)
      [Chromosome.new, Chromosome.new]
    end

    def maybe_mutate!(mutation_rate)
      @bin_str = bin_str.each_char.map do |bit|
        if rand > mutation_rate
          # TODO: Add analytics logger
          # puts "Pristine!"
          bit
        else
          # TODO: Add analytics logger
          # puts "Mutated!"
          String(bit.to_i ^ 1)
        end
      end.join
      self
    end
  end
end
