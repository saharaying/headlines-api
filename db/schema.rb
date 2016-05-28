# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160526152413) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "url"
    t.datetime "pub_date"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "feed_channel_id"
    t.string   "author"
    t.string   "hero_media"
    t.string   "hero_media_type", default: "image"
  end

  add_index "articles", ["feed_channel_id"], name: "index_articles_on_feed_channel_id"

  create_table "articles_categories", force: :cascade do |t|
    t.integer "article_id"
    t.integer "category_id"
  end

  add_index "articles_categories", ["article_id"], name: "index_articles_categories_on_article_id"
  add_index "articles_categories", ["category_id"], name: "index_articles_categories_on_category_id"

  create_table "categories", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feed_channels", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.datetime "last_modified"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "disabled",      default: false
    t.string   "media_type",    default: "image"
  end

end
