class TwitterCrawlerController < ApplicationController
  
  # Controller kann keine helper Methoden aufrufen. Man kann aber eine Controller
  # Methode zum Helper machen:
  helper_method :current_user
  
  def index
  
    @friends = Array.new()
    @followers = Array.new()
    
    if (current_user)
      
      @twitter_client = Twitter::Client.new()
      
      unless (@twitter_client.nil?)
      
        friend_ids = @twitter_client.friend_ids() 
        follower_ids = @twitter_client.follower_ids() 
        
        @friends = user_lookup(friend_ids.ids) unless (friend_ids.nil?)
        @followers = user_lookup(follower_ids.ids) unless (follower_ids.nil?)
      end
    end
  
  end


  def current_user
    session[:user_info]
  end
  
  
  protected
  
  
  # ------------------------------------------------------------------
  # Läuft durch die übergebenen IDs und fragt die zugehörigen User ab.
  #
  # Gibt Mash-Objekte zurück.
  # ------------------------------------------------------------------
  def user_lookup(ids)
    
    users = Array.new()
    
    unless (@twitter_client.nil?)
      users = @twitter_client.users(ids)
    end
    
    
    users
  end
  
  
end
