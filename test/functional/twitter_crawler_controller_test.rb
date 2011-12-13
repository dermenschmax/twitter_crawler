require 'test_helper'

# ------------------------------------------------------------------
# TODO:
#     Zugriffsdaten irgendwo ablegen, nicht in git!
#
# Tests:
#   1. nicht angemeldet  => "bitte anmelden"-Seite
#   2. Authentifikation  -> kann man das testen???
#   3. show "der_mensch_max"   => show-view mit Timeline, friends, follows
#                              => Aktualisieren des Users + der f&fs in der DB
#                              => ggf. crawling
# ------------------------------------------------------------------

class TwitterCrawlerControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  
  # testet, ob die grundlegenden Dinge gesetzt sind und ein Twitter-Aufruf
  # funktioniert
  test "fake_twitter_login" do
    fake_twitter_login
    tc = Twitter::Client.new()
    
    assert_not_nil session[:provider] 
    assert_not_nil session[:uid]
    assert_not_nil session[:credentials]
    assert_not_nil tc.user_timeline("der_mensch_max")
  end
end
