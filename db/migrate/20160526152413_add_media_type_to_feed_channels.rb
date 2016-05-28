class AddMediaTypeToFeedChannels < ActiveRecord::Migration[5.0]
  def change
    add_column :feed_channels, :media_type, :string, default: 'image'
  end
end
