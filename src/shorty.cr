require "kemal"
require "./shorty/*"

get "/" do
  "Hello world"
end

Kemal.run
