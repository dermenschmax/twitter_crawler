class CreateTwitterUsers < ActiveRecord::Migration
  
  def change
    create_table :twitter_users do |t|
      t.string      :name
      t.string     :tw_id_str
      t.string      :screen_name
      
      t.integer     :followers_count
      t.integer     :friends_count
      t.string      :lang
      t.string      :profile_image_url
      t.timestamp   :processed_at
      
      t.timestamps
      
      t.text        :json_data
    end
  end
end
