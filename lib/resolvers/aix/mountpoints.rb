# frozen_string_literal: true

module Facter
  module Resolvers
    module Aix
      class Mountpoints < BaseResolver
        @semaphore = Mutex.new
        @fact_list ||= {}

        class << self
          private

          def post_resolve(fact_name)
            @fact_list.fetch(fact_name) { read_mount(fact_name) }
          end

          def read_mount(fact_name)
            @fact_list[:mountpoints] = {}
            output, _status = Open3.capture2('mount 2>/dev/null')
            output.split("\n").map do |line|
              next if line =~ /\snode\s|---|procfs|ahafs/

              elem = line.split("\s")

              @fact_list[:mountpoints][elem[1]] = { device: elem[0], filesystem: elem[2],
                                                    options: elem.last.split(',') }
            end

            @fact_list[fact_name]
          end
        end
      end
    end
  end
end
