# frozen_string_literal: true

module Prependers
  module Annotate
    class Namespace < Module
      attr_reader :namespace

      def self.[](namespace)
        new(namespace)
      end

      def initialize(namespace)
        @namespace = namespace
      end

      def included(base)
        base.singleton_class.class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def __prependers_namespace__
            #{@namespace}
          end
        RUBY
      end
    end
  end
end
