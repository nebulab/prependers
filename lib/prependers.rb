# frozen_string_literal: true

require "prependers/version"
require "prependers/errors"
require "prependers/prepender"
require "prependers/loader"

module Prependers
  class << self
    def load_paths(*paths, **options)
      paths.flatten.each do |path|
        Loader.new(path, options).load
      end
    end

    def setup_for_rails(load_options = {})
      prependers_directories = Rails.root.join('app', 'prependers').glob('*')

      Rails.application.config.tap do |config|
        config.autoload_paths += prependers_directories

        config.to_prepare do
          Prependers.load_paths(prependers_directories, load_options)
        end
      end
    end
  end
end
