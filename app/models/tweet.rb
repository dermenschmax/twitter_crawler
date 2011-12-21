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
  
  
  def self.create_from_twitter_status(tw_stat)
    t = Tweet.new()
    t.tw_id = tw_stat.id
    t.text = tw_stat.text
    t.retweet_count = tw_stat.retweet_count
    t.in_reply_to_user_id = tw_stat.in_reply_to_user_id
    t.in_reply_to_status_id = tw_stat.in_reply_to_status_id
    t.in_reply_to_screen_name = tw_stat.in_reply_to_screen_name
    t.json_data = tw_stat.to_json()
    
    t
  end
end
