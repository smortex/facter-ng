# frozen_string_literal: true

module ExternalFactsApi
  def search_external(dirs)
    LegacyFacter.search_external(dirs)
  end

  def search_external_path
    LegacyFacter.search_external_path
  end
end
