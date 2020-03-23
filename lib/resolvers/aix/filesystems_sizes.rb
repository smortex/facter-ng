# frozen_string_literal: true

module Facter
  module Resolvers
    module Aix
      class FilesystemsSizes < BaseResolver
        @semaphore = Mutex.new
        @fact_list ||= {}

        class << self
          private

          def post_resolve(fact_name)
            @fact_list.fetch(fact_name) { execute_df_command(fact_name) }
          end

          def execute_df_command(fact_name)
            @fact_list[:sizes] = {}
            output, _status = Open3.capture2('df -P 2>/dev/null')
            output.split("\n").map do |line|
              next if line =~ /Filesystem|-\s+-\s+-/

              elem = line.split("\s")
              compute_sizes(elem)
              @fact_list[:sizes][elem.last].merge!(device: elem[0])
            end

            @fact_list[fact_name]
          end

          def compute_sizes(info)
            available_bytes = info[3].to_i * 512
            used_bytes = info[2].to_i * 512
            size_bytes = info[1].to_i * 512
            @fact_list[:sizes][info.last] = { capacity: FilesystemHelper.compute_capacity(used_bytes, size_bytes),
                                              available_bytes: available_bytes,
                                              used_bytes: used_bytes,
                                              size_bytes: size_bytes,
                                              available: BytesToHumanReadable.convert(available_bytes),
                                              used: BytesToHumanReadable.convert(used_bytes),
                                              size: BytesToHumanReadable.convert(size_bytes) }
          end
        end
      end
    end
  end
end
