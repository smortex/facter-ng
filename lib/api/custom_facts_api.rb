# frozen_string_literal: true

module CustomFactsApi
  def search(*dirs)
    LegacyFacter.search(*dirs)
  end

  def search_path
    LegacyFacter.search_path
  end
end
