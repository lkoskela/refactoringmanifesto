require File.dirname(__FILE__) + '/spec_helper'

describe "Admin page" do
  include Rack::Test::Methods
  def app; @app ||= Sinatra::Application ; end
  
  before(:each) do
    @john, @jane, @jim = ["John", "Jane", "Jim"].collect do |name|
      Signatory.create(:name => name, :created_at => DateTime.now)
    end
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
