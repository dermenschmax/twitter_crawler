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
      config.consumer_key = "x6n3zw1f1W2a6xXeNt9M1g"
      config.consumer_secret = "UdOj3XFVKpdBh0dVcW4GouW6xeFpMXtxCi61TpWNlmA"
      config.oauth_token = session[:credentials]["token"]
      config.oauth_token_secret = session[:credentials]["secret"]
    end

    
    #logger.info("provider: #{omniauth['provider']}")
    #logger.info("uid: #{omniauth['uid']}")
    #logger.info("user_info: #{omniauth['user_info']}")
    #logger.info("session[:user_info]: #{session[:user_info]}")
    
    redirect_to :controller => "twitter_crawler", :action => "show", :id => session[:uid]
    
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
