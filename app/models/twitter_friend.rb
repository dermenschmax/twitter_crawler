# ------------------------------------------------------------------
# Bildet die Friends-Beziehung ab.
#
# Zuordnungstabelle TwitterUser -> TwitterUser
#
# Attribute:
# ------------------------------------------------------------------
class TwitterFriend < ActiveRecord::Base
  belongs_to :twitter_user
  belongs_to :friend, :class_name => "TwitterUser"
end
