# frozen_string_literal: true

module Facts
  module Aix
    class Paritions
      FACT_NAME = 'partitions'

      def call_the_resolver
        fact_value = Facter::Resolvers::Aix::Partitions.resolve(:partitions)
        Facter::ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
