# frozen_string_literal: true

require File.expand_path('../../support/files/prependable', __dir__)

RSpec.describe Prependers::Annotate::Verify do
  it 'raises an error when initialized with nil' do
    expect do
      module Prependable::TestVerification # rubocop:disable Style/ClassAndModuleChildren
        include Prependers::Prepender[verify: nil]
      end
    end.to raise_error(Prependers::OutdatedPrependerError, /have not defined an original hash/)
  end

  it 'does not raise an error when the stored hash matches the current hash' do
    expect do
      module Prependable::TestVerification # rubocop:disable Style/ClassAndModuleChildren
        include Prependers::Prepender[verify: '81a6ffd025f97bd88259b7993ba5945f6b32d0d9']
      end
    end.not_to raise_error
  end

  it 'raises an error when the stored hash does not match the current hash' do
    expect do
      module Prependable::TestVerification # rubocop:disable Style/ClassAndModuleChildren
        include Prependers::Prepender[verify: 'f7175533215c39f3f3328aa5829ac6b1bb168218']
      end
    end.to raise_error(Prependers::OutdatedPrependerError, /the original source has changed/)
  end
end
