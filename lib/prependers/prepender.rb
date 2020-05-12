# frozen_string_literal: true

module Prependers
  class Prepender < Module
    def self.[](options = {})
      new(options)
    end

    attr_reader :options

    NAMESPACE_DEPRECATION = \
      "[DEPRECATION] Passing a namespace to `Prependers::Prepender#[]` is deprecated. Use the " \
      "`:namespace` option instead."

    def initialize(options_or_namespace = {})
      if options_or_namespace.is_a?(Module)
        warn NAMESPACE_DEPRECATION % { namespace: options_or_namespace }
        options_or_namespace = { namespace: options_or_namespace }
      end

      @options = options_or_namespace
    end

    def included(base)
      if options.key?(:namespace)
        base.include Prependers::Annotate::Namespace.new(options[:namespace])
      end

      if options.key?(:verify)
        base.include Prependers::Annotate::Verify.new(options[:verify])
      end

      prependable = Prependers.prependable_for(base)

      prependable.prepend(base)

      if base.const_defined?('ClassMethods')
        prependable.singleton_class.prepend(base.const_get('ClassMethods'))
      end
    end
  end
end
