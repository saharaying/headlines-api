class AddDisabledToFeedChannels < ActiveRecord::Migration[5.0]
  def change
    add_column :feed_channels, :disabled, :boolean, default: false
  end
end
