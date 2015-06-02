module SelectionStrategy
  class IntegerCodexInfixEvaluation
    def create_map(ideal, population)
      fitnesses = population.map { |c| evaluate(c) }
      total_fitness = fitnesses.inject(:+)
      proportional_fitnesses = []

      fitnesses.inject(BigDecimal(0)) do |sum, f|
        proportional_fitnesses << sum + (BigDecimal(f) / total_fitness)
        proportional_fitnesses.last
      end

      proportional_fitnesses.zip(population.to_a)
    end

    def sample(selection_map)
      selection_map.find { |pf, chrom| pf.to_f >= rand }.last
    end

    def evaluate(chromosome)
      denominator = config[:ideal_phenotype] - phenotype(chromosome)
      result = denominator == 0 ? 2.0 : (BigDecimal('1.0') / BigDecimal(denominator)).abs
      BigDecimal("#{result}")
    end

    private

    def codex
      @codons ||= 16.times.map { |n| n.to_s(2).rjust(4, '0') }
      @values ||= (0..9).to_a + [:+, :-, :*, :/]
      @codex  ||= Hash[@codons.zip(@values)]
    end

    def phenotype(chromosome)
      raise("Invalid Chromosome: #{chromosome.inspect}. ",
            "We expect its bin_str length to be exactly divisible by 4. ",
            "Instead, there is a remainder of #{chromosome.bin_str.length % 4}.") unless chromosome.bin_str.length % 4 == 0

      amino_acids = chromosome.bin_str.chars.each_slice(4).map { |codon| codex[codon.join] } << :terminate

      # Curried evaluator function will return itself
      # until it receives arguments of Integer, Symbol, Integer
      # saving past valid arguments
      # and skipping invalid arguments.
      #
      # Eventually returns an Integer via Integer#send(:+|:-|:*|:/, Integer.new)
      evaluator = proc do |n, op, m|
        args = []

        inner_evaluator = proc do |*aas|
          received_terminate = false

          aas.each do |aa|
            received_terminate = true if aa == :terminate
            next args[0] ||= aa if !args[0] && aa.is_a?(Fixnum)
            next args[1] ||= aa if  args[0] && aa.is_a?(Symbol)
            next args[2] ||= aa if  args[1] && aa.is_a?(Fixnum)
          end

          if args.map { |a| a.class } == [Fixnum, Symbol, Fixnum]
            begin
              args[0].send(args[1], args[2])
            rescue ZeroDivisionError
              0
            end
          else
            received_terminate ? args.first : inner_evaluator
          end
        end

        inner_evaluator[n, op, m]
      end

      until amino_acids.empty?
        aa = amino_acids.shift

        # Call maybe_evaluated (an evaluator function holding valid arguments)
        # with new amino_acid if it exists.
        # Otherwise, call a new evaluator function with amino_acid to get things going.
        maybe_evaluated &&= maybe_evaluated[aa]
        maybe_evaluated ||= evaluator[aa]

        # When evaluator returns
        # Prepend Integer result to amino_acids list.
        # Then reset maybe_evaluated to nil.
        if maybe_evaluated.is_a?(Integer)
          amino_acids.unshift(maybe_evaluated)
          maybe_evaluated = nil
        end
      end

      maybe_evaluated && maybe_evaluated[:terminate] || 0
    end
  end
end

