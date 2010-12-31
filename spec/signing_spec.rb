require File.dirname(__FILE__) + '/spec_helper'

describe "Signing the manifesto" do
  include Rack::Test::Methods
  def app; @app ||= Sinatra::Application ; end

  it "should add the signatory to the database" do
    timestamp_before = DateTime.now
    post '/signatories', params={:name => 'John Doe'}
    signatory = Signatory.first(:name => 'John Doe')
    signatory.should_not be_nil
    signatory.name.should == 'John Doe'
    signatory.created_at.should be_between(timestamp_before - 1, DateTime.now + 1)
  end

  it "should redirect after post to avoid accidental duplicates" do
    post '/signatories', params={:name => 'somebody'}
    should_have_redirected_to /\/signatories$/
  end
  
  ['', '  ', '\t', 'abc'].each do |name|
    it "should reject '#{name}' as a signee name" do
      post '/signatories', params={:name => name}
      follow_redirect!
      Signatory.all.size.should == 0
      last_response.body.should have_tag(".error")
    end
  end

  it "should mention the number of signatories to date" do
    quoted_signatories_to_date_should_be 0
    sign_up "Jane Doe", "Jim Doe"
    quoted_signatories_to_date_should_be 2
  end

  it "should list the signatories" do
    people = ["John Doe", "Jane Doe", "Jim Doe"]
    sign_up people
    get '/signatories'
    people.each do |name|
      last_response.body.should include name
    end
  end
end

def sign_up(*names)
  names.each do |name|
    Signatory.create(:name => name, :created_at => DateTime.now)
  end
  names
end
