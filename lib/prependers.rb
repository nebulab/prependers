# frozen_string_literal: true

require "prependers/version"
require "prependers/errors"
require "prependers/prepender"
require "prependers/loader"

module Prependers
  class << self
    def load_paths(*paths, **options)
      Array(paths).each do |path|
        Loader.new(path, options).load
      end
    end
  end
end
