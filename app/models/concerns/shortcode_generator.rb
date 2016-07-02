require 'active_support/concern'

module ShortcodeGenerator
  extend ActiveSupport::Concern

  included do
    def generate_random_shortcode
      [*('a'..'z'),*('A'..'Z'),*('0'..'9')].shuffle[0,6].join
    end
  end

end