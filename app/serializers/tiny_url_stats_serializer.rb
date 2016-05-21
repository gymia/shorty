class TinyUrlStatsSerializer < ActiveModel::Serializer
  format_keys :lower_camel
  attributes :redirect_count, :last_seen_date, :start_date

  def start_date
    object.created_at.iso8601
  end

  def last_seen_date
    object.last_seen_at.try(:iso8601)
  end
end
