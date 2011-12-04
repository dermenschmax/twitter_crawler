class TwitterCrawlerController < ApplicationController
  
  # Controller kann keine helper Methoden aufrufen. Man kann aber eine Controller
  # Methode zum Helper machen:
  helper_method :current_user
  
  def index
  
  end

  # Params:
  #   id   => zu zeigender User
  def show
    
    @friends = Array.new()
    @followers = Array.new()
    @user_id = params[:id]
    
    unless (@user_id.nil?)
      
      @twitter_client = Twitter::Client.new()
      
      unless (@twitter_client.nil?)
        friend_ids = @twitter_client.friend_ids(@user_id.to_i) 
        follower_ids = @twitter_client.follower_ids(@user_id.to_i) 
        
        @user = lookup_single_user(@user_id)
        @friends = user_lookup(friend_ids.ids) unless (friend_ids.nil?)
        @followers = user_lookup(follower_ids.ids) unless (follower_ids.nil?)
        @user_tweets = @twitter_client.user_timeline(@user_id.to_i, :include_entities => 1)
      end
      
      logger.info("@user = #{@user}")
    end
  end



  def current_user
    session[:user_info]
  end
  
  
  # ------------------------------------------------------------------
  # Zeichnet einen Gesprächsfluss nach. Der wird in Twitter über @mentions
  # abgebildet.
  # ------------------------------------------------------------------
  def conversation
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
      users = @twitter_client.users(ids.first(100), :include_entities => 1)
    end
    
    
    users
  end
  
  
  def lookup_single_user(id)
    unless (@twitter_client.nil?)
      user = @twitter_client.user(id.to_i, :include_entities => 1)
    end
    
    user
  end
  
  
end
