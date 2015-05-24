$: << File.expand_path('.')

require 'rspec'
require 'genalg'

CONFIG = {
  crossover_rate: 0.7,
  mutation_rate: 0.002,
  num_generations: 100,
  num_simulations: 10
}

CONFIG[:num_simulations].times do
  describe Simulation do
    before :all do
      simulation = described_class.new(CONFIG)
      @original_population = simulation.population
      simulation.run
      @resultant_population = simulation.population
    end

    subject { described_class.new(CONFIG) }

    describe '#run' do
      it "calls #next_generation #{CONFIG[:num_generations]} times" do
        expect(subject).to receive(:next_generation).exactly(CONFIG[:num_generations]).times
        subject.run
      end

      it "terminates with a #population.average_fitness larger than the original Population's" do
        expect(@original_population.average_fitness).to be > @resultant_population.average_fitness
      end

      it "terminates with a #fittest Chromosome fitter than the original Population's" do
        expect(@original_population.fittest.fitness).to be > @resultant_population.fittest.fitness
      end
    end
  end
end
