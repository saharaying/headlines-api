class AddHeroImageToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :hero_image, :string
  end
end
