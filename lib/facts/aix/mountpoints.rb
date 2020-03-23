# frozen_string_literal: true

module Facts
  module Aix
    class Mountpoints
      FACT_NAME = 'mountpoints'

      def call_the_resolver
        Facter::ResolvedFact.new(FACT_NAME, construct_mountpoints)
      end

      def construct_mountpoints
        mountpoints = Facter::Resolvers::Aix::Mountpoints.resolve(:mountpoints)
        sizes = Facter::Resolvers::Aix::FilesystemsSizes.resolve(:sizes)

        mountpoints.each { |mount, _value| mountpoints[mount].merge!(sizes[mount]) if sizes[mount] }
        mountpoints
      end
    end
  end
end
