# frozen_string_literal: true

module Prependers
  class Error < StandardError; end

  class NoPrependerError < Error; end

  class OutdatedPrependerError < Error; end
end
