class Article < ApplicationRecord
  belongs_to :feed_channel
  has_and_belongs_to_many :categories

  def category
    categories.first.try :label
  end

  def channel
    feed_channel.title || feed_channel.url
  end
end
