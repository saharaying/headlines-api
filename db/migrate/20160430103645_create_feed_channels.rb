class CreateFeedChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :feed_channels do |t|
      t.string :url
      t.string :title
      t.datetime :last_modified
      t.timestamps
    end
  end
end
