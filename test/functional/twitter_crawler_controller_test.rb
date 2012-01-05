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
  #test "fake_twitter_login" do
  #  fake_twitter_login
  #  tc = Twitter::Client.new()
  #  
  #  assert_not_nil(session[:provider], "provider should be stored in session")
  #  assert_not_nil(session[:uid], "uid should be stored in session")
  #  assert_not_nil(session[:credentials], "credentials should be stored in session")
  #  assert_not_nil(tc.user_timeline("der_mensch_max"), "twitter client should be able to read user timeline")
  #end
  
  
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
  #test "show" do
  #  
  #  sn = "der_mensch_max"
  #  fake_twitter_login()
  #  
  #  user_cnt = TwitterUser.count()
  #  
  #  get :show, :screen_name => sn
  #  
  #  user_cnt2 = TwitterUser.count()
  #  
  #  assert_response(:success, "show should return success")
  #  assert_not_nil(assigns["friends"], "should set @friends")
  #  assert_not_nil(assigns["followers"], "should set @followers")
  #  assert_not_nil(assigns["user"], "should set @user")
  #  assert_not_nil(assigns["user_tweets"], "should set @user_tweets")
  #  assert((user_cnt + assigns["friends"].size + assigns["followers"].size + 1)== user_cnt2,
  #         "#{user_cnt} + #{assigns["friends"].size} + #{assigns["followers"].size} +1 == #{user_cnt2} ")
  #
  #  tw = TwitterUser.find_by_screen_name(sn)
  #  assert_not_nil(tw, "user in database")
  #
  #  assert(tw.friends.count() == assigns["friends"].size, "friends in db: #{tw.friends.count()}, @friends: #{assigns["friends"].size}")
  #  assert(tw.followers.count() == assigns["followers"].size, "followers in db: #{tw.followers.count()}, @followers: #{assigns["followers"].size}")
  #  
  #  assert(TwitterFollower.count() == tw.followers.count(), "TwitterFollower.count() == tw.followers.count, but #{TwitterFollower.count()} != #{tw.followers.count()}")
  #  assert(TwitterFriend.count() == tw.friends.count(), "TwitterFriend.count() == tw.friends.count, but #{TwitterFriend.count()} != #{tw.friends.count()}")
  #
  #end
  
  
   # testet eine Subroutine von show, in der entschieden wird, ob ein nur user aus 
   # der Datenbank kommt oder von Twitter geladen wird.
   #
   # Szenario:
   #    - user anlegen
   #    - show aufrufen
   #    => user wird nicht aktualisiert (updated_at)
  #test "process_user" do
  #  
  #  fake_twitter_login()
  #  sn = "der_mensch_max"
  #  get :show, :screen_name => sn       # TwitterUser wurde angelegt (inkl. f&f)
  #  
  #  tw = TwitterUser.find_by_screen_name(sn)
  #  assert_not_nil(tw, "found ref user in db")
  #  
  #  # beim zweiten Aufruf darf der User nicht aktualisiert werden (updated_at ist gleich)
  #  get :show, :screen_name => sn
  #  tw2 = TwitterUser.find_by_screen_name(sn)
  #  assert_not_nil(tw2, "found ref user in db again")
  #  assert(tw.updated_at == tw2.updated_at, "should not be updated -> #{tw.updated_at} == #{tw2.updated_at}")
  #end
  
  
   # get-request für User in der Datenbank. Wenn der User vor <heute> das letzte Mal aktualisiert
   # wurde, gibt es trotzdem einen api Aufruf
  #test "process_user_yesterday" do
  #  fake_twitter_login()
  #  sn = "der_mensch_max"
  #  
  #  get :show, :screen_name => sn       # TwitterUser wurde angelegt (inkl. f&f)
  #  
  #  tw = TwitterUser.find_by_screen_name(sn)        # 
  #  assert_not_nil(tw, "found ref user in db")
  #  tw_yesterday = tw.updated_at - 86400            # "Gestern" berechnen
  #  
  #  tw.updated_at = Time.now - 172800  # 2 Tage     # Aktualisierung weit zurück drehen
  #  assert(tw.save, "save updated user")
  #  
  #  tw2 = TwitterUser.find_by_screen_name(sn)       # DB-Wert überprüfen
  #  assert(tw2.updated_at < tw_yesterday, "should be updated before yesterday, but is #{tw2.updated_at} tw: #{tw.updated_at}")
  #  
  #  get :show, :screen_name => sn                   # get request soll user aktualisieren (da alt)
  #  tw3 = TwitterUser.find_by_screen_name(sn)
  #  assert_not_nil(tw3, "found ref user in db once again")
  #  assert(tw.updated_at < tw3.updated_at, "should be updated -> #{tw.updated_at} < #{tw3.updated_at}")
  #end
  
  
  # Beim Aktualisieren des Users (TwitterUser.create_or_update) wird immer der
  # letzte Tweet (status) gespeichert, wenn nicht schon vorhanden.
  #
  # In diesem Test existiert der status noch nicht
  #test "last_tweet" do
  #  
  #  fake_twitter_login()
  #  sn = "der_mensch_max"
  #  
  #  get :show, :screen_name => sn           # TwitterUser wurde angelegt (inkl. f&f)
  #  
  #  tw = TwitterUser.find_by_screen_name(sn)        # 
  #  assert_not_nil(tw, "found ref user in db")
  #  assert((tw.tweets.count() > 0), "user should have tweets")
  #  
  #end
  
  
  # Beim Aktualisieren des Users (TwitterUser.create_or_update) wird immer der
  # letzte Tweet (status) gespeichert, wenn nicht schon vorhanden.
  #
  # In diesem Test existiert der status bereits und wird nicht überschrieben oder
  # verdoppelt
  #test "last_tweet_exists" do
  #  fake_twitter_login()
  #  sn = "der_mensch_max"
  #  
  #  get :show, :screen_name => sn           # TwitterUser wurde angelegt (inkl. f&f)
  #  
  #  tw = TwitterUser.find_by_screen_name(sn)        # 
  #  assert_not_nil(tw, "found ref user in db")
  #  assert((tw.tweets.count() > 0), "user should have tweets")
  #  
  #  tweet_cnt = tw.tweets.count()
  #  tw.updated_at = Time.now - 172800       # Aktualisierung weit zurück drehen
  #  assert(tw.save, "save updated user")
  #  user_updated = tw.updated_at
  #  
  #  puts "first get - listing Tweets"
  #  Tweet.find(:all).each() do |tw|
  #    puts("Tweet: #{tw.id} - #{tw.tw_id_str} - #{tw.text}")
  #  end
  #  
  #  
  #  get :show, :screen_name => sn
  #  
  #  puts "second get - listing Tweets"
  #  Tweet.all.each() do |tw|
  #    puts("Tweet: #{tw.id} - #{tw.tw_id_str} - #{tw.text}")
  #  end
  #  
  #  
  #  tw2 = TwitterUser.find_by_screen_name(sn)
  #  assert_not_nil(tw2, "user found again in db")
  #  assert((tw2.updated_at > tw.updated_at), "user should be updated")
  #  assert((tw2.tweets.count() == tweet_cnt), "no new tweets for ref user, expected: #{tweet_cnt} but is: #{tw2.tweets.count()}")
  #end
  
   # testet, ob nach dem zweiten get-Aufruf die Anzahl friends & followers noch gleich ist
   #
  test "ff_count" do
    
    fake_twitter_login()
    sn = "der_mensch_max"
    get :show, :screen_name => sn       # TwitterUser wurde angelegt (inkl. f&f)
    
    tw = TwitterUser.find_by_screen_name(sn)
    assert_not_nil(tw, "found ref user in db")
    friends_cnt = tw.friends.count()
    followers_cnt = tw.followers.count()
    
    # beim zweiten Aufruf darf der User nicht aktualisiert werden (updated_at ist gleich)
    get :show, :screen_name => sn
    tw2 = TwitterUser.find_by_screen_name(sn)
    assert_not_nil(tw2, "found ref user in db again")
    assert(tw2.friends.count() == friends_count, "friends.count() should be the same -> #{friends_count} == #{tw2.friends.count()}")
    assert(tw2.followers.count() == followers_count, "followers.count() should be the same -> #{followers_count} == #{tw2.followers.count()}")
  end  
  
  
  
  # Testet, ob beim Speichern des Tweets auch HashTags und Mentions gespeichert
  # werden
  #test "entities" do
  #  assert false
  #end
  
  
end
