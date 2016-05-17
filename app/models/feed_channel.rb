class FeedChannel < ApplicationRecord
  has_many :articles
  scope :enabled, -> { where(disabled: false) }
end
