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

    def initialize(bin_str=rand(32).to_s(2).rjust(5, '0'))
      @bin_str = bin_str
    end

    def fitness
      rand
    end

    def size
      bin_str.length
    end

    def maybe_crossover!(other, crossover_rate, analysis)
      analysis[:crossovers][:chances] += 1
      if rand > crossover_rate
        [self, other]
      else
        cx_point = rand(self.size)
        first_child = self.bin_str[0..cx_point] + other.bin_str[cx_point..-1]
        second_child = other.bin_str[0..cx_point] + self.bin_str[cx_point..-1]

        analysis[:crossovers][:occurences] += 1
        [Chromosome(first_child), Chromosome(second_child)]
      end
    end

    def maybe_mutate!(mutation_rate, analysis)
      @bin_str = bin_str.each_char.map do |bit|
        analysis[:mutations][:chances] += 1
        if rand > mutation_rate
          bit
        else
          analysis[:mutations][:occurences] += 1
          String(bit.to_i ^ 1)
        end
      end.join
      self
    end
  end
end
