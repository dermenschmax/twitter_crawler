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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111219105212) do

  create_table "tweets", :force => true do |t|
    t.integer  "twitter_user_id"
    t.string   "tw_id_str"
    t.text     "text"
    t.integer  "retweet_count"
    t.integer  "in_reply_to_user_id"
    t.integer  "in_reply_to_status_id"
    t.string   "in_reply_to_screen_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "json_data"
  end

  create_table "twitter_followers", :force => true do |t|
    t.integer  "twitter_user_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_friends", :force => true do |t|
    t.integer  "twitter_user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_users", :force => true do |t|
    t.string   "name"
    t.string   "tw_id_str"
    t.string   "screen_name"
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.string   "lang"
    t.string   "profile_image_url"
    t.datetime "processed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "json_data"
  end

end
