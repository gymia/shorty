module Slugifier
  extend ActiveSupport::Concern

  module ClassMethods
    def slugify(attribute, options = {})
      regexp_string = options.delete(:with)
      before_create(options) do
        loop do
          send("#{attribute}=", generate_code(regexp_string))
          break unless self.class.exists?(attribute => public_send(attribute))
        end
      end
    end
  end

  private
    def generate_code(regexp_string)
      require 'faker'
      Faker::Base.regexify(Regexp.new(regexp_string))
    end
end
