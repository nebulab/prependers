# frozen_string_literal: true

require "digest"

require "prependers/version"
require "prependers/errors"
require "prependers/annotate/namespace"
require "prependers/annotate/verify"
require "prependers/prepender"
require "prependers/loader"

module Prependers
  def self.load_paths(*paths, **options)
    paths.flatten.each do |path|
      Loader.new(path, options).load
    end
  end

  def self.setup_for_rails(load_options = {})
    prependers_directories = Rails.root.join('app', 'prependers').glob('*')

    Rails.application.config.tap do |config|
      config.autoload_paths += prependers_directories

      config.to_prepare do
        Prependers.load_paths(prependers_directories, load_options)
      end
    end
  end

  def self.prependable_for(prepender)
    prependable = prepender.name.split('::')[0..-2].join('::')

    if prepender.respond_to?(:__prependers_namespace__)
      prependable = (prependable[(prepender.__prependers_namespace__.name.length + 2)..-1]).to_s
    end

    Object.const_get(prependable)
  end
end
