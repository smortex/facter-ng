# frozen_string_literal: true

module Facter
  module Resolvers
    module Aix
      class Partitions < BaseResolver
        @semaphore = Mutex.new
        @fact_list ||= {}
        class << self
          private

          def post_resolve(fact_name)
            @fact_list.fetch(fact_name) { query_cudv(fact_name) }
          end

          def query_cudv(fact_name)
            @fact_list[:partitions] = {}

            odmquery = Facter::ODMQuery.new
            odmquery.equals('PdDvLn', 'logical_volume/lvsubclass/lvtype')

            result = odmquery.execute

            return unless result

            result.each_line do |line|
              next unless line.include?('name')

              part = '/dev/' + line.split('=')[1].strip.delete('"')
              @fact_list[:partitions][part] = {}
            end
            populate_from_cuat

            @fact_list[fact_name]
          end

          def populate_from_cuat
            @fact_list[:partitions].keys.each do |part|
              name = part.gsub('/dev/', '')

              @fact_list[:partitions][part] = { filesystem: query_for(name, 'type'),
                                               label: query_for(name, 'label') }
            end
          end

          def query_for(name, attribute)
            odmquery = Facter::ODMQuery.new
            odmquery.equals('name', name).equals('attribute', attribute)

            result = odmquery.execute

            result.each_line do |line|
              next unless line =~ /value/

              return line.split('=')[1].strip.delete('"')
            end
          end
        end
      end
    end
  end
end
