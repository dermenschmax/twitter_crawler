ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def fake_twitter_login
    
    # Dummy-Werte in die Session setzen
    session[:provider] = "twitter"
    session[:uid] = "123456"
    session[:credentials] = {}
    session[:user_info] = {"nickname"=>"test",
                                "name"=>"test"}
  end
end
