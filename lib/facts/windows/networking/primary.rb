# frozen_string_literal: true

module Facts
  module Windows
    module Networking
      class Primary
        FACT_NAME = 'networking.primary'

        def call_the_resolver
          fact_value = Facter::Resolvers::Networking.resolve(:primary)

          Facter::ResolvedFact.new(FACT_NAME, fact_value)
        end
      end
    end
  end
end
