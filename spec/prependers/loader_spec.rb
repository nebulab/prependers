# frozen_string_literal: true

require_relative '../support/files/prependable'

RSpec.describe Prependers::Loader do
  subject(:loader) { described_class.new(File.expand_path('../support/files/loader', __dir__), namespace: Acme) }

  before do
    if defined?(Acme::Prependable::AutoloadedPrepender)
      Acme::Prependable.send(:remove_const, :AutoloadedPrepender)
    end

    load File.expand_path('../support/files/loader/acme/prependable/autoloaded_prepender.rb', __dir__)

    if defined?(Acme::Prependable::AlreadyLoadedPrepender)
      Acme::Prependable.send(:remove_const, :AlreadyLoadedPrepender)
    end

    load File.expand_path('../support/files/loader/acme/prependable/already_loaded_prepender.rb', __dir__)
  end

  it 'activates all prependers in the given path' do
    loader.load

    expect(Prependable.ancestors.first).to eq(Acme::Prependable::AutoloadedPrepender)
  end

  it 'raises a NoPrependerError when a module is not defined' do
    if defined?(Acme::Prependable::AutoloadedPrepender)
      Acme::Prependable.send(:remove_const, :AutoloadedPrepender)
    end

    expect { loader.load }.to raise_error(Prependers::NoPrependerError)
  end

  it 'does not re-include Prependers::Prepender when already included' do
    loader.load

    ancestors = Acme::Prependable::AlreadyLoadedPrepender.ancestors
    prepender_ancestors = ancestors.count do |ancestor|
      ancestor.is_a?(Prependers::Prepender)
    end

    expect(prepender_ancestors).to eq(1)
  end
end
