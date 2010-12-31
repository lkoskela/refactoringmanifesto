require File.dirname(__FILE__) + '/spec_helper'

describe "Login page" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end
  
  before(:each) do
    @admin_username = 'correct_username'
    @admin_password = 'correct_password'
    User.register(@admin_username, @admin_password)
    get "/login"
  end
  
  def log_in(username = @admin_username, password = @admin_password)
    post '/login', { :username => username, :password => password }
  end
  
  it "should render a login form for GET requests" do
    last_response.body.should have_tag("//form//input[@name='username']")
    last_response.body.should have_tag("//form//input[@name='password']")
  end
  
  it "should reject authentication with missing username" do
    log_in(username = 'nosuchuser')
    should_have_redirected_to %r{/login$}
  end

  it "should reject authentication with wrong password" do
    log_in(password = 'wrongpassword')
    should_have_redirected_to %r{/login$}
  end
  
  it "should accept authentication with correct credentials" do
    log_in
    should_have_redirected_to %r{/admin$}
  end

end
