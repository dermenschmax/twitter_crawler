class TwitterFollower < ActiveRecord::Base
  belongs_to :twitter_user
  belongs_to :follower, :class_name => "TwitterUser"
end
