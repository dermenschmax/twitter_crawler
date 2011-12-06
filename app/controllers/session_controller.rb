class SessionController < ApplicationController

  def create
    
    omniauth = request.env['omniauth.auth']
    session[:provider] = omniauth['provider']
    session[:uid] = omniauth['uid']
    session[:credentials] = omniauth['credentials']
    session[:user_info] = omniauth['user_info']
    
    #uoi = Hash.new()
    #uoi["name"] = current_user["name"]
    #uoi["nickname"] = current_user["nickname"]
    #uoi["image"] = current_user["image"]
    #uoi["uid"] = session[:uid]
    #session[:uoi] = uoi
    
    # feed the magic twitter
    Twitter.configure do |config|
      #config.consumer_key = wird vom gem gesetzt
      #config.consumer_secret = wird im initializer gesetzt
      config.oauth_token = session[:credentials]["token"]
      config.oauth_token_secret = session[:credentials]["secret"]
    end

    
    #logger.info("provider: #{omniauth['provider']}")
    #logger.info("uid: #{omniauth['uid']}")
    #logger.info("user_info: #{omniauth['user_info']}")
    #logger.info("session[:user_info]: #{session[:user_info]}")
    #logger.info("session[:user_info]['nick_name']: #{session[:user_info]['nickname']}")
    
    redirect_to :controller => "twitter_crawler", :action => "show", :screen_name => session[:user_info]["nickname"]
    
  end
  
  def signout
    session[:provider] = nil
    session[:uid] = nil
    session[:credentials] = nil
    session[:user_info] = nil
    
    session.delete(:provider)
    session.delete(:uid)
    session.delete(:credentials)
    session.delete(:user_info)
    
    redirect_to :controller => "twitter_crawler", :action => "index"
  end

end
