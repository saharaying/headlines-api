class AddFeedChannelIdToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :feed_channel_id, :integer
    add_index :articles, :feed_channel_id
  end
end
