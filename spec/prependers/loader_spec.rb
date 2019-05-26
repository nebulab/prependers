# frozen_string_literal: true

RSpec.describe Prependers::Loader do
  describe '#load' do
    context 'without a namespace' do
      let(:path) { File.expand_path('../support/files/prependers/without_namespace', __dir__) }

      before do
        class Lion; end
        Dir.glob("#{path}/**/*.rb") { |f| require(f) }
      end

      it 'loads the prependers' do
        described_class.new(path).load

        expect(Lion.new.roar).to eq('Roar!')
      end
    end

    context 'with a namespace' do
      let(:path) { File.expand_path('../support/files/prependers/with_namespace', __dir__) }

      before do
        class Mouse; end
        Dir.glob("#{path}/**/*.rb") { |f| require(f) }
      end

      it 'loads the prependers' do
        described_class.new(path, namespace: Acme).load

        expect(Mouse.new.squeak).to eq('Squeak!')
      end
    end
  end
end
