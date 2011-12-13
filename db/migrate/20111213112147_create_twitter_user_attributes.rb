class CreateTwitterUserAttributes < ActiveRecord::Migration
  def change
    create_table :twitter_user_attributes do |t|

      t.integer   :tw_user_id
      t.string    :key
      t.text      :value

      t.timestamps
    end
  end
end
