require "./base_repository"

class Shorty::MemoryRepository < Shorty::BaseRepository
  def initialize
    @entries = {} of String => UrlEntry
    @number_of_entries = 0
    @last_entry_at = Time.now
  end

  def get(code)
    @entries[code]?
  end

  def put(url_entry)
    @entries[url_entry.code] = url_entry
    return true
  end

  def exists?(code)
    @entries.has_key?(code)
  end
end
