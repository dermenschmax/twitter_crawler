class CreateTwitterFriends < ActiveRecord::Migration
  def change
    create_table :twitter_friends do |t|
      t.integer     :twitter_user_id
      t.integer     :friend_id, :class_name => "TwitterUser"
      t.timestamps
    end
  end
end
