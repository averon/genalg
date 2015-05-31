$: << File.expand_path('.')

require 'rspec'
require 'genalg'

def config
  {
    crossover_rate: 0.7,
    mutation_rate: 0.002,
    num_generations: 100,
    num_simulations: 10,
    population_size: 100
  }
end

config[:num_simulations].times do
  describe Simulation do

    subject { described_class.new(config) }

    before :all do
      simulation = described_class.new(config)
      @original_population = simulation.population
      simulation.run
      @resultant_population = simulation.population
    end

    describe '#run' do
      it "calls #next_generation #{config[:num_generations]} times" do
        expect(subject).to receive(:next_generation).exactly(config[:num_generations]).times
        subject.run
      end

      it "terminates with a #population.average_fitness larger than the original Population's" do
        expect(@original_population.average_fitness).to be > @resultant_population.average_fitness
      end

      it "terminates with a #fittest Chromosome fitter than the original Population's" do
        expect(@original_population.fittest.fitness).to be > @resultant_population.fittest.fitness
      end

      it "begins and ends population.size equal to config[:population_size]" do
        expect(@original_population.size).to eq(@resultant_population.size)
      end
    end

    describe '#population' do
      it "returns a Population" do
        expect([@original_population, @resultant_population]).to all be_a Population
      end
    end

    describe '#select_chromosomes' do
      it "returns two Chromosomes" do
        expect(subject.select_chromosomes).to all be_a Chromosome
      end
    end
  end
end
