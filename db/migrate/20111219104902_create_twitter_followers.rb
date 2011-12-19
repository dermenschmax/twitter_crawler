class CreateTwitterFollowers < ActiveRecord::Migration
  def change
    create_table :twitter_followers do |t|
      t.integer     :twitter_user_id
      t.integer     :follower_id, :class_name => "TwitterUser"
      t.timestamps
    end
  end
end
