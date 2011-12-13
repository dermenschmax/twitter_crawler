# ------------------------------------------------------------------
# Der Twitter-User.
#
# In der Tabelle werden nur wenige Kernattribute gehalten.
#
# Attribute:
#    t.string   "name"
#    t.integer  "tw_id"
#    t.string   "screen_name"
#    t.integer  "followers_count"
#    t.integer  "friends_count"
#    t.string   "lang"
#    t.string   "profile_image_url"
#    t.datetime "created_at"
#    t.datetime "updated_at"
# ------------------------------------------------------------------
class TwitterUser < ActiveRecord::Base
  
  
end
