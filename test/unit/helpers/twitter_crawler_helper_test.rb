require 'test_helper'

class TwitterCrawlerHelperTest < ActionView::TestCase
  
  test "kein_mention" do
    
    # 1. kein Mention: t == s
    t = "Hallo, kein Mention"
    s = link_mentions_helper(t)
    
    assert_not_nil(s)
    assert_equal(s, t, "kein mention enthalten '#{t}' != '#{s}'")
  end
  
  test "ein_mention"do
    t = "Hallo, ein @Mention im Text"
    s = link_mentions_helper(t)
    
    assert_not_nil(s)
    assert_not_equal(s, t, "#{t} soll einen Link enthalten '#{s}'")
    assert(s.index("<a href") >= 0)
    assert(s.index("</a>") > 0)
  end

  test "nur_mention" do
    t = "@Mention"
    s = link_mentions_helper(t)
    
    assert_not_nil(s)
    assert_not_equal(s, t, "#{t} erhaelt einen Link '#{s}'")
    assert(s.index("<a") >= 0, "Link-Anfang fehlt #{s}")
    assert(s.index("</a>") > 0, "Link-Ende fehlt #{s}")
  end
  
  test "zwei_mentions" do
    assert(false)
  end
  
end
