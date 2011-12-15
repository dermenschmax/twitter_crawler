# ------------------------------------------------------------------
# Der Twitter-User.
#
# In der Tabelle werden nur wenige Kernattribute gehalten.
#
# Attribute:
#    t.string   "name"
#    t.integer  "tw_id"
#    t.string   "screen_name"
#    t.integer  "followers_count"
#    t.integer  "friends_count"
#    t.string   "lang"
#    t.string   "profile_image_url"
#    t.datetime "created_at"
#    t.datetime "updated_at"
#    t.text     "json_data"
# ------------------------------------------------------------------
class TwitterUser < ActiveRecord::Base
  
  validates_presence_of :name
  validates_presence_of :tw_id
  validates_presence_of :screen_name
  validates_presence_of :followers_count
  validates_presence_of :friends_count
  validates_presence_of :lang
  validates_presence_of :profile_image_url
  
  # ------------------------------------------------------------------
  # Erzeugt und speichert TwitterUser mit den im Mashie gespeicherten Daten
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
    self.tw_id = user_mashie.id
    self.screen_name = user_mashie.screen_name
    self.followers_count = user_mashie.followers_count
    self.friends_count = user_mashie.friends_count
    self.lang = user_mashie.lang
    self.profile_image_url = user_mashie.profile_image_url
    self.json_data = user_mashie.to_json()
    self.updated_at = Time.now()
  end
  
  
end
