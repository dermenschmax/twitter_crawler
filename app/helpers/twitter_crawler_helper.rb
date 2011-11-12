module TwitterCrawlerHelper

  def current_user
    session[:user_info]
  end

end
