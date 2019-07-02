# frozen_string_literal: true

module Prependers
  class Loader
    attr_reader :base_path, :options

    def initialize(base_path, options = {})
      @base_path = Pathname.new(File.expand_path(base_path))
      @options = options
    end

    def load
      Dir.glob("#{base_path}/**/*.rb").sort.each do |path|
        absolute_path = Pathname.new(File.expand_path(path))
        relative_path = absolute_path.relative_path_from(base_path)

        prepender_module_name = expected_module_for(relative_path)

        unless Object.const_defined?(prepender_module_name)
          error = <<~ERROR
            Expected #{absolute_path} to define #{prepender_module_name}, but module is not defined.

            Note that Prependers does not require files automatically - you will have to do that
            yourself before calling `#load_paths`.
          ERROR

          raise NoPrependerError, error
        end

        prepender_module = Object.const_get(prepender_module_name)
        prepender_module.include Prepender.new(options[:namespace])
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
