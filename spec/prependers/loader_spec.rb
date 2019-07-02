# frozen_string_literal: true

RSpec.describe Prependers::Loader do
  describe '#load' do
    context 'without a namespace' do
      let(:path) { File.expand_path('../support/files/prependers/without_namespace', __dir__) }

      before do
        class Lion; end
        Dir.glob("#{path}/**/*.rb") { |f| require(f) }
        described_class.new(path).load
      end

      it 'loads the prependers' do
        expect(Lion.new.roar).to eq('Roar!')
      end

      it 'loads in alphabetical order' do
        expect(Lion.ancestors.first).to eq(Lion::AddTail)
      end
    end

    context 'with a namespace' do
      let(:path) { File.expand_path('../support/files/prependers/with_namespace', __dir__) }

      before do
        class Mouse; end
        Dir.glob("#{path}/**/*.rb") { |f| require(f) }
        described_class.new(path, namespace: Acme).load
      end

      it 'loads the prependers' do
        expect(Mouse.new.squeak).to eq('Squeak!')
      end

      it 'loads in alphabetical order' do
        expect(Mouse.ancestors.first).to eq(Acme::Mouse::AddTail)
      end
    end
  end
end
