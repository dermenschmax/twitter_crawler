# ---------------------------------------------------------------------------
# Ein simpler tweet collector. Sammelt über die anoyme Twitter Search API alle
# tweets mit lang = "de"
#
# ---------------------------------------------------------------------------


require "rubygems"
require "twitter"


t = Time.new
now = t.year.to_s + "-"+t.month.to_s + "-" + t.day.to_s
tweet_cnt = 0

search = Twitter::Search.new
search.not_containing("jaslkjda").language("de").since_date(now).each() do |t|
  puts("#{t.from_user} -> #{t.to_user}: #{t.text}")
  tweet_cnt += 1
end

puts "#{tweet_cnt} tweets gelesen"

