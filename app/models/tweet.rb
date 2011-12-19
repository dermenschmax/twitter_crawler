# ------------------------------------------------------------------
# Ein Tweet
#
#
# t.integer  "twitter_user_id"
# t.integer  "tw_id"
# t.text     "text"
# t.integer  "retweet_count"
# t.integer  "in_reply_to_user_id"
# t.integer  "in_reply_to_status_id"
# t.string   "in_reply_to_screen_name"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.text     "json_data"
# ------------------------------------------------------------------
class Tweet < ActiveRecord::Base
  
  belongs_to :twitter_user
end
