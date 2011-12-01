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
  # Verlinkt die user_mentions in dem übergebenen String.
  #
  # Parameter:
  #   text    der zu verlinkende Text (der tweet)
  #
  # Rückgabe:
  #   der neue Text mit links drin
  #
  # Test
  #   twitter_crawler_helper_test::link_mention_helper
  # ------------------------------------------------------------------
  def link_mentions_helper(text)
    s = ""
    unless (text.nil?)
      text.lines(" ") do |l|
        if (!l.nil? && l.size > 0 && l[0] == "@") then
          s += "<a href='#'>#{l.strip}</a> "
        else
          s += l
        end
      end
    end
    
    s
  end

end
