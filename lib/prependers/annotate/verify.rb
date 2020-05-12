# frozen_string_literal: true

module Prependers
  module Annotate
    class Verify < Module
      WRONG_HASH_ERROR = \
        "The stored hash for %{prepended_module} in %{prepender} is %{stored_hash}, but the " \
        "current hash is %{current_hash} instead.\n\n" \
        "This most likely means that the original source has changed.\n\n" \
        "Check that your prepender is still valid, then update the stored hash:\n\n" \
        "    include Prependers::Prepender[verify: '%{current_hash}']"

      UNSET_HASH_ERROR = \
        "You have not defined an original hash for %{prepended_module} in %{prepender}.\n\n" \
        "You can define the hash by updating your include statement as follows:\n\n" \
        "    include Prependers::Prepender[verify: '%{current_hash}']"

      attr_reader :original_hash

      def self.[](original_hash)
        new(original_hash)
      end

      def initialize(original_hash)
        @original_hash = original_hash
      end

      def included(prepender)
        prependable = Prependers.prependable_for(prepender)
        current_hash = compute_hash(prependable)

        return if current_hash == original_hash

        error = (original_hash ? WRONG_HASH_ERROR : UNSET_HASH_ERROR) % {
          prepended_module: prependable,
          prepender: prepender.name,
          stored_hash: original_hash,
          current_hash: current_hash,
        }

        raise OutdatedPrependerError, error
      end

      private

      def compute_hash(constant)
        methods = constant.methods(false).map(&constant.method(:method)) +
                  constant.instance_methods(false).map(&constant.method(:instance_method))

        raise NameError, "#{constant} has no methods" if methods.empty?

        source_locations = methods.map(&:source_location).compact.map(&:first).uniq.sort

        contents = source_locations.map { |path| File.read(path) }.join

        Digest::SHA1.hexdigest(contents)
      end
    end
  end
end
