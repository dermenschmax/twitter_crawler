module TwitterCrawlerHelper

  def short_date(d)
    
    ret = ""
    
    unless (d.nil?)
      date = Date.parse(d)
      
      if (Date.today == date)
        ret = "today"
      else
        ret = date.strftime("%a, %d %b")  
      end
      
    end
    
    ret
  end
  
  
  def join_hash_tags(hash_tags)
    hash_tags.collect{|ht| "#"+ht.text}.join(" ; ")
  end
  
  def join_mentions(user_mentions)
    user_mentions.collect{|um| "@"+um.screen_name}.join(" ; ") unless user_mentions.nil?
  end
  
  
  # ------------------------------------------------------------------
  # Verlinkt die user_mentions in dem übergebenen String. Durch das Escaping
  # ist die Methode kompliziert. Wir teilen den String in mehrere Teile. Es wird
  # ein Array zurück geliefert. Teile davon stammen direkt aus dem Tweet (unsicher)
  # und Teile sind von uns (sicher). 
  #
  # Parameter:
  #   text    der zu verlinkende Text (der tweet)
  #
  # Rückgabe:
  #   das oben beschriebene Array
  #
  # Test
  #   twitter_crawler_helper_test::link_mention_helper
  # ------------------------------------------------------------------
  
  def link_mentions_helper(text)
    a = []
    
    unless (text.nil?)
      text.lines(" ") do |l|
        if (!l.nil? && l.size > 0 && l[0] == "@") then
          lt = link_to(l.strip, url_for(:action => "conversation"))
          a << lt
        else
          a << l
        end
      end
    end
    
    a
  end

end
