class TwitterCrawlerController < ApplicationController
  
  # Controller kann keine helper Methoden aufrufen. Man kann aber eine Controller
  # Methode zum Helper machen:
  helper_method :current_user, :current_user_name, :current_user_screen_name,
                :trunc_date, :yesterday
  
  
  
  # ------------------------------------------------------------------
  # Wird nur gezeigt, wenn der User noch nicht angemeldet ist
  #
  # ------------------------------------------------------------------
  def index
  
  end


  # ------------------------------------------------------------------
  # Zeigt Details zum übergebenen User.
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
      @friends = process_friends()
      @followers = process_followers()
     
      
    logger.debug("TwFollower.count: #{TwitterFollower.count()}")
      
    TwitterFollower.all.each() do |tf|
      logger.debug("Follower: #{tf.twitter_user.screen_name} -> #{tf.follower.screen_name}") unless (tf.nil? ||tf.twitter_user.nil? || tf.follower.nil?)
    end
      
      unless (@twitter_client.nil?)
        @user_tweets = @twitter_client.user_timeline(@user.screen_name, :include_entities => 1)
        
      end
      
      logger.info("@user = #{@user}")
    end
  end


  # ------------------------------ helper ---------------------------#


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
  
  
  # ------------------------------------------------------------------
  # Beschneidet ein Datum auf Sekunden
  # ------------------------------------------------------------------
  def trunc_date(d)
    Time.mktime(d.year, d.month, d.day) unless d.nil?
  end
  
  
  # ------------------------------------------------------------------
  # Liefert "Gestern", selbe Zeit
  # ------------------------------------------------------------------
  def yesterday
    Time.now() - 86400
  end
  
  # ------------------------------ helper ---------------------------#

  
  
  protected
  
  
  # ------------------------------------------------------------------
  # Sucht den User heraus. Falls notwendig werden Informationen von Twitter
  # geholt.
  #
  # Gibt das TwitterUser-Objekt des users zurück.Benötigt @twitter_client
  #
  # Lesen aus der Datenbank vs. Lesen von Twitter
  #       --> aus der DB lesen, wenn vorhanden und Datensatz <heute> schon
  #           aktualisiert wurde, user_timeline immer von Twitter
  #       (3) von Twitter, wenn
  #                 a) User nicht vorhanden oder
  #                 b) User nicht nach dem letzten Status aktualisiert wurde
  #
  # Parameter:
  #     sn      screen_name
  # ------------------------------------------------------------------
  def process_user(sn)
    tw_user = TwitterUser.find_by_screen_name(sn)
    
    today = trunc_date(Time.now())
    
    if (tw_user.nil? || tw_user.updated_at < today) then
      @user = lookup_screen_name(sn)
          
      tw_user = TwitterUser.create_or_update(@user)
      tw_user.save!
    end
    
    tw_user
  end
  


  # ------------------------------------------------------------------
  # Bearbeitet die Leute, denen der angezeigte User folgt (friends)
  #
  # Gibt ein Array mit den zugehörigen Usern zurück. Es wird eine Auswahl (s. u.)
  # geliefert
  #
  # Lesen aus der Datenbank vs. Lesen von Twitter
  #   - Freundesliste wird von Twitter geholt, wenn
  #     -> der User <heute> angelegt oder geändert wurde
  #
  #   - die Freunde werden von Twitter geholt, wenn sie nicht vorhanden sind oder 
  #     nicht <heute> aktualisiert wurden
  #
  # Auswahl der anzuzeigenden friends:
  #       - TODO
  #
  # Vorbedinung:
  #     @user ist gesetzt
  #
  # 
  # ------------------------------------------------------------------  
  def process_friends
    today = trunc_date(Time.now)
    
    if ( today == trunc_date(@user.created_at) || tw_user.updated_at < today) then
      
      logger.debug("[process_friends] loading friend_ids from twitter")
      
      friend_ids = @twitter_client.friend_ids(@user.screen_name) 
      friends = user_lookup(friend_ids.ids) unless (friend_ids.nil?)
      
      friends.each() do |f|
        @user.friends << f
      end
      
      @user.save!
    else
      logger.debug("[process_friends] reading friends from database")
      
      friends = @user.friends  
    end
  
    friends
  end
  
  def process_followers
    today = trunc_date(Time.now())
    
    if ( today == trunc_date(@user.created_at) || tw_user.updated_at < today) then
      follower_ids = @twitter_client.follower_ids(@user.screen_name) 
      followers = user_lookup(follower_ids.ids) unless (follower_ids.nil?)
      
      followers.each() do |f|
        @user.followers << f
      end
      
      @user.save!
    else
      followers = @user.followers
    end
    
    followers
  end
  
  
  # ------------------------------------------------------------------
  # Läuft durch die übergebenen IDs und fragt die zugehörigen User ab.
  # Sortiert nach Datum des letzten Tweets.
  #
  # Gibt TwitterUser-Objekte zurück.
  #
  # Algorithmus:
  #   - Basis: die ersten 100 IDs, die werden gezeigt
  #   - die aussuchen, die erfragt werden müssen (Kriterien s. show)
  # ------------------------------------------------------------------
  def user_lookup(ids)
    
    twitter_users = Array.new()
    
    users = @twitter_client.users(ids.first(100), :include_entities => 1) unless (@twitter_client.nil?)
    
    
    # User speichern
    users.each do |u|
      tw = TwitterUser.create_or_update(u)
      tw.save!
      twitter_users << tw
    end
    
    # Ergebnis nach Datum des letzten Tweets (status) sortieren
    #twitter.users.sort_by! do |u|
    #  unless (u.status.nil?) then        
    #    d = Date.parse(u.status.created_at)
    #  else
    #    Date.new(1970)
    #  end
    #end
    # TODO: geht nicht 
    
    
    # Absteigend sortieren
    twitter_users.reverse!
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
