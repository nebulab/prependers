module Acme
  module Prependable
    module AlreadyLoadedPrepender
      include Prependers::Prepender[namespace: Acme]
    end
  end
end
