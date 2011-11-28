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

end
