# frozen_string_literal: true

module Prependers
  class Loader
    UNDEFINED_PREPENDER_ERROR = \
      "Expected `%{path}` to define `%{prepender}`, but it is not defined.\n\n" \
      "This is most likely because the file has not been required.\n\n" \
      "Require the file yourself before calling `Prependers.load_paths`."

    attr_reader :base_path, :options

    def initialize(base_path, options = {})
      @base_path = Pathname.new(File.expand_path(base_path))
      @options = options
    end

    def load
      Dir.glob("#{base_path}/**/*.rb").sort.each do |path|
        absolute_path = Pathname.new(File.expand_path(path))
        relative_path = absolute_path.relative_path_from(base_path)

        prepender_name = expected_module_for(relative_path)

        unless Object.const_defined?(prepender_name)
          raise NoPrependerError, UNDEFINED_PREPENDER_ERROR % {
            path: absolute_path,
            prepender: prepender_name,
          }
        end

        prepender = Object.const_get(prepender_name)

        if prepender.ancestors.none? { |ancestor| ancestor.is_a?(Prependers::Prepender) }
          prepender.include(Prepender.new(options))
        end
      end
    end

    private

    def expected_module_for(path)
      path = path.to_s[0..-(File.extname(path).length + 1)]

      return path.camelize if path.respond_to?(:camelize)

      path.to_s.gsub('/', '::').split('::').map do |part|
        part.split('_').map(&:capitalize).join
      end.join('::')
    end
  end
end
