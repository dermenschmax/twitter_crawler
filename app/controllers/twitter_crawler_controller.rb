class TwitterCrawlerController < ApplicationController
  
  # Controller kann keine helper Methoden aufrufen. Man kann aber eine Controller
  # Methode zum Helper machen:
  helper_method :current_user
  
  def index
  
  end

  # Params:
  #   screen_name   => zu zeigender User
  def show
    
    @friends = Array.new()
    @followers = Array.new()
    sn = params[:screen_name]
    
    unless (sn.nil?)
      
      @twitter_client = Twitter::Client.new()
      
      unless (@twitter_client.nil?)
        
        @user = lookup_screen_name(sn)
        friend_ids = @twitter_client.friend_ids(@user.screen_name) 
        follower_ids = @twitter_client.follower_ids(@user.screen_name) 
        
        
        @friends = user_lookup(friend_ids.ids) unless (friend_ids.nil?)
        @followers = user_lookup(follower_ids.ids) unless (follower_ids.nil?)
        @user_tweets = @twitter_client.user_timeline(@user.screen_name, :include_entities => 1)
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
  #
  # Parameter:
  #   persa:          screen_name der sprechenden Person A (da wurde gerade geklickt)
  #   persb:          screen_name der angesprochenen Person
  #   tweet_date:     Datum des Tweets, 
  # ------------------------------------------------------------------
  def conversation()
    @twitter_client = Twitter::Client.new()
    name_a = params[:persa]
    name_b = params[:persb]
    tweet_date = params[:tweet_date]
    
    @user_a = lookup_screen_name(name_a)
    @user_b = lookup_screen_name(name_b)
    
    unless(@twitter_client.nil?)
      @user_a_tweets = @twitter_client.user_timeline(@user_a.screen_name, :include_entities => 1)
      @user_b_tweets = @twitter_client.user_timeline(@user_b.screen_name, :include_entities => 1)
    end
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
  
  
  def lookup_screen_name(sn)
    
    unless (@twitter_client.nil? || sn.nil?)
      user = @twitter_client.user(sn, :include_entities => 1)
    end
    
    user
  end
  
  
end
