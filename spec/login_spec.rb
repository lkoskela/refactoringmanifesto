require File.dirname(__FILE__) + '/spec_helper'

describe "Login page" do
  include Rack::Test::Methods
  include Webrat::Matchers

  def app
    @app ||= Sinatra::Application
  end

  before(:each) do
    @admin_username = 'correct_username'
    @admin_password = 'correct_password'
    User.register(@admin_username, @admin_password)
    get "/login"
  end

  def log_in(parameters={})
    opts = {:username => @admin_username, :password => @admin_password }
    opts.update(parameters)
    opts[:password] = SHA1.hash(opts[:password])
    post '/login', opts
  end

  def log_out
    get '/logout'
  end

  it "should render a login form for GET requests" do
    last_response.body.should have_xpath("//form//input[@name='username']")
    last_response.body.should have_xpath("//form//input[@name='password']")
  end

  it "should reject authentication with missing username" do
    log_in(:username => 'nosuchuser')
    should_have_redirected_to %r{/login$}
    response_body_after_redirect.should have_xpath("//*[@class='error']")
  end

  it "should reject authentication with wrong password" do
    log_in(:username => @admin_username, :password => 'wrongpassword')
    should_have_redirected_to %r{/login$}
    response_body_after_redirect.should have_xpath("//*[@class='error']")
  end

  it "should accept authentication with correct credentials" do
    log_in
    should_have_redirected_to %r{/admin$}
    response_body_after_redirect.should_not have_selector(".error")
  end

  it "is shown after log out" do
    log_in
    should_have_redirected_to %r{/admin$}
    log_out
    get '/admin'
    should_have_redirected_to %r{/login$}
  end
end
