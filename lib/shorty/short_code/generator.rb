module Shorty
  module Shortcode
    class Generator
      # TODO: check if generated code already exists(if so, re-generate it)
      def self.run
        # ASCII 2^8 == 256 == 0..255(thanks internets :p)
        # All ASCII chars that matches the regex are taken randomly from sample
        (0..255).map(&:chr).select{|x| x =~ /[0-9a-zA-Z_]/}.sample(6).join
      end
    end
  end
end
