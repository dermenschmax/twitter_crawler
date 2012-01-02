class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :twitter_user_id
      
      t.string :tw_id_str
      t.text    :text
      t.integer :retweet_count
      t.integer :in_reply_to_user_id
      t.integer :in_reply_to_status_id
      t.string  :in_reply_to_screen_name
      
      t.timestamps
      
      t.text    :json_data
    end
  end
end
