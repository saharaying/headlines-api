class AddHeroMediaToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :hero_media, :string
    add_column :articles, :hero_media_type, :string, default: 'image'
  end
end
