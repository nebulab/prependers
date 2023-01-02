# frozen_string_literal: true

RSpec.describe Prependers do
  describe '.load_paths' do
    it 'instantiates and executes a Loader' do
      args = ['foo']
      options = { namespace: 'test' }
      loader = instance_spy('Prependers::Loader')
      allow(Prependers::Loader).to receive(:new).with(*args, **options).and_return(loader)

      described_class.load_paths(*args, **options)

      expect(loader).to have_received(:load)
    end
  end

  describe '.setup_for_rails' do
    it 'adds prepender directories to the autoload_paths'
    it 'loads all prepender directories'
  end
end
