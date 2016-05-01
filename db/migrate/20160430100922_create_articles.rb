class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :url
      t.datetime :pub_date
      t.timestamps
    end
  end
end
