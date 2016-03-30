require "../url_entry"

abstract class Shorty::BaseRepository
  abstract def get(code : String) : UrlEntry?
  abstract def put(url_entry : UrlEntry) : Bool
  abstract def exists?(code : String) : Bool
end
