class DateTime
  def self.shorty_current
    now.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
  end
end
