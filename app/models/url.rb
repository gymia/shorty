class Url < ApplicationRecord
  extend FriendlyId
  friendly_id :short_code, use: :slugged
end
