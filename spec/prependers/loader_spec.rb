# frozen_string_literal: true

require_relative '../support/files/prependable'

RSpec.describe Prependers::Loader do
  subject(:loader) { described_class.new(File.expand_path('../support/files/loader', __dir__), namespace: Acme) }

  it 'activates all prependers in the given path' do
    require_relative '../support/files/loader/acme/prependable/autoloaded_prepender'

    loader.load

    expect(Prependable.ancestors.first).to eq(Acme::Prependable::AutoloadedPrepender)
  end

  it 'raises a NoPrependerError when a module is not defined' do
    if defined?(Acme::Prependable::AutoloadedPrepender)
      Acme::Prependable.send(:remove_const, :AutoloadedPrepender)
    end

    expect { loader.load }.to raise_error(Prependers::NoPrependerError)
  end
end
