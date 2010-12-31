require File.dirname(__FILE__) + '/spec_helper'

describe "Admin page" do
  include Rack::Test::Methods
  def app; @app ||= Sinatra::Application ; end
  
  before(:each) do
    @admin_username = 'admin'
    @admin_password = 'secret'
    User.register(@admin_username, @admin_password)
  end
  
  before(:each) do
    @john, @jane, @jim = ["John", "Jane", "Jim"].collect do |name|
      Signatory.create(:name => name, :created_at => DateTime.now)
    end
  end
  
  def log_in(username = @admin_username, password = @admin_password)
    post '/login', { :username => username, :password => password }
  end
  
  describe "with an authenticated user" do
    before(:each) do
      log_in
    end

    it "should mention the number of signatories to date" do
      get '/admin'
      quoted_signatories_to_date_should_be 3
    end

    it "should list the signatories" do
      get '/admin'
      [@john, @jane, @jim].each do |s|
        last_response.body.should include s.name
      end
    end

    it "should delete signatories" do
      get "/admin/destroy/#{@jane.id}"
      Signatory.get(@jane.id).should == nil
      quoted_signatories_to_date_should_be 2
    end

    it "should redirect back to original URL after delete" do
      get "/admin/destroy/#{@jane.id}"
      should_have_redirected_to /\/admin$/
    end
  end
  
  describe "without an authenticated user" do
    it "should redirect to login page" do
      get "/admin"
      should_have_redirected_to %r{/login$}
    end
    
    it "should redirect to the originally requested page after successful login" do
      get "/admin/whatever"
      log_in
      should_have_redirected_to %r{/admin/whatever$}
    end
  end

  describe "login" do
    it "should reject authentication with missing username" do
      get "/admin/whatever"
      log_in('nosuchuser', 'whatever')
      should_have_redirected_to %r{/login$}
    end

    it "should reject authentication with wrong password" do
      get "/admin/whatever"
      log_in(password = 'wrong')
      should_have_redirected_to %r{/login$}
    end
  end
end
