class CreateTwitterUsers < ActiveRecord::Migration
  
  def change
    create_table :twitter_users do |t|
      t.string      :name
      t.integer     :tw_id
      t.string      :screen_name
      
      t.integer     :followers_count
      t.integer     :friends_count
      t.string      :lang
      t.string      :profile_image_url
      
      t.timestamps
      
      t.text        :json_data
    end
  end
end
