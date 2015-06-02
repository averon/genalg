$: << File.expand_path('.')

require 'rspec'
require 'genalg'

config[:num_simulations].times do
  describe Simulation do
    subject { described_class.new }

    before :all do
      simulation = described_class.new
      @original_population = simulation.population
      simulation.run
      @resultant_population = simulation.population
      @run_report = ANALYSIS
    end

    describe '#run' do
      it "calls #next_generation #{config[:num_generations]} times" do
        expect(subject).to receive(:next_generation).exactly(config[:num_generations]).times
        subject.run
      end

      it "terminates with a #population.average_fitness larger than the original Population's" do
        expect(@resultant_population.average_fitness).to be >= @original_population.average_fitness
      end

      it "terminates with a #fittest Chromosome fitter than the original Population's" do
        expect(@resultant_population.fittest.fitness).to be >= @original_population.fittest.fitness
      end

      it "begins and ends population.size equal to config[:population_size]" do
        expect(@original_population.size).to eq(@resultant_population.size)
      end

      it "returns a run report" do
        expect(subject.run).to eq(ANALYSIS)
      end

      it "finds at least one ideal chromosome" do
        expect(subject.run[:solutions]).to be > 0
      end
    end

    describe '#population' do
      it "returns a Population" do
        expect([@original_population, @resultant_population]).to all be_a Population
      end

      it "is an array like collection of Chromosomes" do
        expect(@original_population.to_a + @resultant_population.to_a).to all be_a Chromosome
      end
    end

    describe '#analysis' do
      it "logs a reasonable actual crossover rate" do
        expect(@run_report[:crossovers][:occurences] / @run_report[:crossovers][:chances].to_f).to be_between(config[:crossover_rate] - 0.2, config[:crossover_rate] + 0.2)
      end

      it "logs a reasonable actual mutation rate" do
        expect(@run_report[:mutations][:occurences] / @run_report[:mutations][:chances].to_f).to be_between(config[:mutation_rate] - 0.002, config[:mutation_rate] + 0.002)
      end
    end
  end
end
