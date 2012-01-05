# ------------------------------------------------------------------
# Der Twitter-User.
#
# In der Tabelle werden nur wenige Kernattribute gehalten.
#
# Attribute:
#    t.string   "name"
#    t.string   "tw_id_str"
#    t.string   "screen_name"
#    t.integer  "followers_count"
#    t.integer  "friends_count"
#    t.string   "lang"
#    t.string   "profile_image_url"
#    t.datetime "processed_at"
#    t.datetime "created_at"
#    t.datetime "updated_at"
#    t.text     "json_data"
# ------------------------------------------------------------------
class TwitterUser < ActiveRecord::Base
  
  validates_presence_of :name
  validates_presence_of :tw_id_str
  validates_uniqueness_of :tw_id_str
  validates_presence_of :screen_name
  validates_presence_of :followers_count
  validates_presence_of :friends_count
  validates_presence_of :lang
  validates_presence_of :profile_image_url
  
  has_many :twitter_friends
  has_many :friends, :through => :twitter_friends
  
  has_many :twitter_followers
  has_many :followers, :through => :twitter_followers
  
  has_many :tweets
  
  # ------------------------------------------------------------------
  # DEPRECATED: Erzeugt und speichert TwitterUser mit den im Mashie gespeicherten Daten
  #
  # Parameter:
  #   user_mashie   Mashie    die Attribute
  # ------------------------------------------------------------------
  def self.build(user_mashie)
    tw = TwitterUser.new()
    tw.refresh(user_mashie)
    
    tw
  end
  
  
  # ------------------------------------------------------------------
  # Erzeugt und speichert oder aktualisiert einen TwitterUser mit den
  # im Mashie gespeicherten Daten
  #
  # Parameter:
  #   user_mashie   Mashie    die Attribute
  # ------------------------------------------------------------------ 
  def self.create_or_update(user_mashie)
    
    unless (user_mashie.nil?)
      tw = TwitterUser.find_by_screen_name(user_mashie.screen_name) || TwitterUser.new()
      
      tw.refresh!(user_mashie)
      
      tw
    end
  end
  
  
  # ------------------------------------------------------------------
  # Aktualisiert die Attributwerte
  #
  # Parameter:
  #   user_mashie   Mashie    die Attribute
  # ------------------------------------------------------------------
  def refresh!(user_mashie)
    self.name = user_mashie.name
    self.tw_id_str = user_mashie.id_str
    self.screen_name = user_mashie.screen_name
    self.followers_count = user_mashie.followers_count
    self.friends_count = user_mashie.friends_count
    self.lang = user_mashie.lang
    self.profile_image_url = user_mashie.profile_image_url
    self.json_data = user_mashie.to_json()
    self.updated_at = Time.now()
    
    # self.processed_at wird nicht gesetzt
    
    unless (user_mashie.status.nil?)
      last_tweet = user_mashie.status

      #t = Tweet.find_by_tw_id_str(last_tweet.id)
      t = Tweet.where("tw_id_str = ?", last_tweet.id_str)
        
      if (screen_name == "der_mensch_max") then
          logger.debug("[refresh!] last_tweet.id: #{last_tweet.id}")
          logger.debug("[refresh!] t.count(): #{t.count()}")
      #    logger.debug("[refresh!] Tweet.count(): #{Tweet.count()}")
      #    logger.debug("[refresh!] tweets.count()(): #{tweets.count()}")
      #    
      #    logger.debug("[refresh!] dumping tweets ")
      #    Tweet.all.each() do |tw|
      #      logger.debug("[refresh!] saved tweet #{tw.id} -> #{tw.tw_id_str} - #{tw.text}")
      #    end
      end   
        
      if (t.nil? || t.count() == 0) then
        
        logger.debug("[refresh!] create tweet for tw_id_str #{last_tweet.id_str} -> #{last_tweet.text}") if (screen_name == "der_mensch_max")
        
        tw = Tweet.create_from_twitter_status(last_tweet)
        tw.save!
        
        logger.debug("[refresh!] created tweed id: #{tw.id}, tw_id_str: #{tw.tw_id_str}") if (screen_name == "der_mensch_max")
        
        self.tweets << tw
      end
    end
    
  end


  # ------------------------------------------------------------------
  # Liefert den letzten Tweet des Users. Convenience Methode
  #
  # Parameter:
  #   
  # ------------------------------------------------------------------
  def last_tweet
    tweets.order("updated_at desc").first unless (tweets.nil? || tweets.size == 0)
  end
  
end
