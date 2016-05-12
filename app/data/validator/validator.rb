class Validator

  def self.blank?(value)
    value.nil? || value.empty?
  end

  def self.match?(value)
    /^[0-9a-zA-Z_]{4,}$/.match value
  end

  def self.exists?(value)
    
  end
end
