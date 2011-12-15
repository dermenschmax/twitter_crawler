class TwitterCrawlerController < ApplicationController
  
  # Controller kann keine helper Methoden aufrufen. Man kann aber eine Controller
  # Methode zum Helper machen:
  helper_method :current_user, :current_user_name, :current_user_screen_name
  
  
  
  # ------------------------------------------------------------------
  # Wird nur gezeigt, wenn der User noch nicht angemeldet ist
  #
  # ------------------------------------------------------------------
  def index
  
  end


  # ------------------------------------------------------------------
  # Zeigt Details zum übergebenen User.
  #
  # TODO: Lesen aus der Datenbank vs. Lesen von Twitter
  #       (1) nur von Twitter lesen, wenn User nicht in lokaler DB, user_timeline
  #           immer von Twitter
  #       (2) aus der DB lesen, wenn vorhanden und Datensatz <heute> schon
  #           aktualisiert wurde, user_timeline immer von Twitter
  #       (3) von Twitter, wenn
  #                 a) User nicht vorhanden oder
  #                 b) User nicht nach dem letzten Status aktualisiert wurde 
  # 
  # Params:
  #   screen_name   => zu zeigender User
  #  
  # Setzt
  #   @friends
  #   @followers
  #   @user
  #   @user_tweets
  # ------------------------------------------------------------------
  def show
    
    @friends = Array.new()
    @followers = Array.new()
    sn = params[:screen_name]
    
    unless (sn.nil?)
      
      @twitter_client = Twitter::Client.new()
      @user = process_user(sn)
      
      unless (@twitter_client.nil?)
        
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
  
  def current_user_name
    session[:user_info]["name"]
  end
  
  # ------------------------------------------------------------------
  # Bestimmt den screen_name des angemeldeten Users aus der Session
  # ------------------------------------------------------------------
  def current_user_screen_name
    session[:user_info]["nickname"]
  end
  

  
  
  protected
  
  
  # ------------------------------------------------------------------
  # Sucht den User heraus. Falls notwendig werden Informationen von Twitter
  # geholt.
  #
  # Gibt das TwitterUser-Objekt des users zurück.Benötigt @twitter_client
  #
  # Parameter:
  #     sn      screen_name
  # ------------------------------------------------------------------
  def process_user(sn)
    tw_user = TwitterUser.find_by_screen_name(sn)
    
    #if (tw_user.nil?) then
      @user = lookup_screen_name(sn)
          
      tw_user = TwitterUser.create_or_update(@user)
      tw_user.save!
    #end
    
    tw_user
  end
  
  
  # ------------------------------------------------------------------
  # Läuft durch die übergebenen IDs und fragt die zugehörigen User ab.
  # Sortiert nach Datum des letzten Tweets.
  #
  # Gibt Mash-Objekte zurück.
  #
  # Algorithmus:
  #   - Basis: die ersten 100 IDs, die werden gezeigt
  #   - die aussuchen, die erfragt werden müssen (Kriterien s. show)
  # ------------------------------------------------------------------
  def user_lookup(ids)
    
    users = Array.new()
    
    unless (@twitter_client.nil?)
      users = @twitter_client.users(ids.first(100), :include_entities => 1)
    end
    
    # User speichern
    users.each do |u|
      tw = TwitterUser.create_or_update(u)
      tw.save!
    end
    
    # Ergebnis nach Datum des letzten Tweets (status) sortieren
    users.sort_by! do |u|
      unless (u.status.nil?) then        
        d = Date.parse(u.status.created_at)
      else
        Date.new(1970)
      end
    end
    
    # Absteigend sortieren
    users.reverse!
  end
  
  
  # ------------------------------------------------------------------
  # Sucht einen User anhand der übergebenen ID
  #
  # Params:
  #     id    twitter user id
  #
  # Returns:
  #   user als Mash
  # ------------------------------------------------------------------
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
