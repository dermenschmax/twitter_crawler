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
    
    assert_not_nil(session[:provider], "provider should be stored in session")
    assert_not_nil(session[:uid], "uid should be stored in session")
    assert_not_nil(session[:credentials], "credentials should be stored in session")
    assert_not_nil(tc.user_timeline("der_mensch_max"), "twitter client should be able to read user timeline")
  end
  
  
  # Zeigt Details zum übergebenen User
  # 
  # Params:
  #   screen_name   => zu zeigender User
  #  
  # Setzt
  #   @friends
  #   @followers
  #   @user
  #   @user_tweets
  test "show" do
    
    sn = "der_mensch_max"
    fake_twitter_login()
    
    user_cnt = TwitterUser.count()
    
    get :show, :screen_name => sn
    
    user_cnt2 = TwitterUser.count()
    
    assert_response(:success, "show should return success")
    assert_not_nil(assigns["friends"], "should set @friends")
    assert_not_nil(assigns["followers"], "should set @followers")
    assert_not_nil(assigns["user"], "should set @user")
    assert_not_nil(assigns["user_tweets"], "should set @user_tweets")
    assert((user_cnt + assigns["friends"].size + assigns["followers"].size + 1)== user_cnt2,
           "#{user_cnt} + #{assigns["friends"].size} + #{assigns["followers"].size} +1 == #{user_cnt2} ")

    tw = TwitterUser.find_by_screen_name(sn)
    assert_not_nil(tw, "user in database")

  end
  
  
  # testet eine Subroutine von show, in der entschieden wird, ob ein nur user aus 
  # der Datenbank kommt oder von Twitter geladen wird.
  #
  # Szenario:
  #     - user anlegen
  #     - show aufrufen
  #     => user wird nicht aktualisiert (updated_at)
  test "process_user" do
    
    fake_twitter_login()
    sn = "der_mensch_max"
    get :show, :screen_name => sn       # TwitterUser wurde angelegt (inkl. f&f)
    
    tw = TwitterUser.find_by_screen_name(sn)
    assert_not_nil(tw, "found ref user in db")
    
    # beim zweiten Aufruf darf der User nicht aktualisiert werden (updated_at ist gleich)
    get :show, :screen_name => sn
    tw2 = TwitterUser.find_by_screen_name(sn)
    assert_not_nil(tw2, "found ref user in db again")
    assert(tw.updated_at == tw2.updated_at, "should not be updated -> #{tw.updated_at} == #{tw2.updated_at}")
  end
  
  
  # get-request für User in der Datenbank. Wenn der User vor <heute> das letzte Mal aktualisiert
  # wurde, gibt es trotzdem einen api Aufruf
  test "process_user_yesterday" do
    fake_twitter_login()
    sn = "der_mensch_max"
    
    get :show, :screen_name => sn       # TwitterUser wurde angelegt (inkl. f&f)
    
    tw = TwitterUser.find_by_screen_name(sn)        # 
    assert_not_nil(tw, "found ref user in db")
    tw_yesterday = tw.updated_at - 86400            # "Gestern" berechnen
    
    tw.updated_at = Time.now - 172800  # 2 Tage     # Aktualisierung weit zurück drehen
    assert(tw.save, "save updated user")
    
    tw2 = TwitterUser.find_by_screen_name(sn)       # DB-Wert überprüfen
    assert(tw2.updated_at < tw_yesterday, "should be updated before yesterday, but is #{tw2.updated_at} tw: #{tw.updated_at}")
    
    get :show, :screen_name => sn                   # get request soll user aktualisieren (da alt)
    tw3 = TwitterUser.find_by_screen_name(sn)
    assert_not_nil(tw3, "found ref user in db once again")
    assert(tw.updated_at < tw3.updated_at, "should be updated -> #{tw.updated_at} < #{tw3.updated_at}")
  end
  
  
end
