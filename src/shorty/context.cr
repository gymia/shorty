require "http"

class HTTP::Server
  class Context
    def repository
      @repository.not_nil!
    end

    def repository=(new_repository)
      @repository = new_repository
    end
  end
end


