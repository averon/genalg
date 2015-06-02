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

    def initialize(bin_str=nil)
      @bin_str = bin_str || random_bin_str
    end

    def fitness
      config[:selection_strategy].evaluate(self)
    end

    def size
      bin_str.length
    end

    def maybe_crossover!(other)
      ANALYSIS[:crossovers][:chances] += 1
      if rand > config[:crossover_rate]
        [self, other]
      else
        cx_point = rand(self.size)
        first_child = self.bin_str[0...cx_point] + other.bin_str[cx_point..-1]
        second_child = other.bin_str[0...cx_point] + self.bin_str[cx_point..-1]

        ANALYSIS[:crossovers][:occurences] += 1
        [Chromosome(first_child), Chromosome(second_child)]
      end
    end

    def maybe_mutate!
      @bin_str = bin_str.each_char.map do |bit|
        ANALYSIS[:mutations][:chances] += 1
        if rand > config[:mutation_rate]
          bit
        else
          ANALYSIS[:mutations][:occurences] += 1
          String(bit.to_i ^ 1)
        end
      end.join
      self
    end

    private

    def random_bin_str
      max_bin_str = '1' * config[:chromosome_size]
      max_as_int = max_bin_str.to_i(2)
      random_int = rand(max_as_int + 1)

      random_int.to_s(2).rjust(max_bin_str.size, '0')
    end
  end
end
