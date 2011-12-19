require 'test_helper'

class TwitterUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "user_show" do 
    assert true
  end
  
  
  test "create_simple_user" do
    
    tw = TwitterUser.new()
    assert !tw.valid?
    
    tw.name = "create_simple_user"
    assert !tw.valid?
    
    tw.tw_id = 2
    assert !tw.valid?
    
    tw.screen_name = "sn"
    assert !tw.valid?
    
    tw.followers_count = 1
    assert !tw.valid?
    
    tw.friends_count = 2
    assert !tw.valid?
    
    tw.lang = "en"
    assert !tw.valid?
    
    tw.profile_image_url = "/"
    assert tw.valid?
      
    assert tw.save
  end
  
  
  test "assign_a_friend" do
    tw = generate_valid_user("one")
    tw.save!
    
    f = generate_valid_user("ones_friend")
    f.save!
    
    assert tw.friends.size() == 0
    tw.friends << f
    
    tw_reloaded = TwitterUser.find(tw.id)
    assert tw_reloaded.friends.size() == 1
  end
  
  
  test "assign_a_follower" do
    tw = generate_valid_user("one")
    tw.save!
    
    f = generate_valid_user("ones_follower")
    f.save!
    
    assert tw.followers.size() == 0
    tw.followers << f
    
    tw_reloaded = TwitterUser.find(tw.id)
    assert tw_reloaded.followers.size() == 1
  end
  
  
  
  # Hilfsmethode für Schreibfaule
  def generate_valid_user(name)
    tw = TwitterUser.new()
    tw.name = name
    tw.tw_id = tw.object_id
    tw.screen_name = name
    tw.followers_count = 0
    tw.friends_count = 0
    tw.lang = "en"
    tw.profile_image_url = "/"
    assert tw.valid?
    
    tw
  end
  
end
