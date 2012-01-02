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
  
  
  def short_timestamp(ts)
    
    unless (ts.nil?)
      ret = if (ts.today?)
              "today" 
            else
              ts.strftime("%a, %d %b")  
            end
    else
      ""
    end
    
  end
  
  
  def join_hash_tags(hash_tags)
    hash_tags.collect{|ht| "#"+ht.text}.join(" ; ")
  end
  
  def join_mentions(user_mentions)
    user_mentions.collect{|um| "@"+um.screen_name}.join(" ; ") unless user_mentions.nil?
  end
  
  
  # ------------------------------------------------------------------
  # Liefert ein Datum im Format %Y-%m-%d %H:%M:%S zurück.
  # ------------------------------------------------------------------
  def date_with_time(d)
    
    unless (d.nil?)
      
      dt = Date.parse(d)
      
      dt.strftime("%F %T")
    end
  end
  
  
  # ------------------------------------------------------------------
  # Verlinkt die user_mentions in dem übergebenen String. Durch das Escaping
  # ist die Methode kompliziert. Wir teilen den String in mehrere Teile. Es wird
  # ein Array zurück geliefert. Teile davon stammen direkt aus dem Tweet (unsicher)
  # und Teile sind von uns (sicher). 
  #
  # Parameter:
  #   text        der zu verlinkende Text (der tweet)
  #   tweet_date  Datum des Tweets (für den Conversation-Link)
  #
  # Rückgabe:
  #   das oben beschriebene Array
  #
  # Test
  #   twitter_crawler_helper_test::link_mention_helper
  # ------------------------------------------------------------------
  
  def link_mentions_helper(text, tweet_date)
    a = []
    
    unless (text.nil?)
      text.lines(" ") do |l|
        if (!l.nil? && l.size > 0 && l.start_with?("@")) then
          persb = l.delete("@").strip()
          t_date = date_with_time(tweet_date)
          lt = link_to(l.strip, url_for(:controller => "twitter_crawler", :action => "conversation", :persa=> @user.screen_name, :persb => persb, :tweet_date => t_date))
          a << lt
        else
          a << l
        end
      end
    end
    
    a
  end

end
