require File.dirname(__FILE__) + '/spec_helper'

describe "Signing the manifesto" do
  include Rack::Test::Methods
  include Webrat::Matchers
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
  
  it "should reject signee names shorter than 2 characters" do
    should_reject_signee_name "A"
  end
  
  it "should accept signee names of at least 2 non-whitespace characters" do
    should_accept_signee_name "AB"
    should_accept_signee_name "ABC"
  end
  
  it "should reject all-whitespace names for a signee" do
    should_reject_signee_name "   "
    should_reject_signee_name "\t\t\t"
    should_reject_signee_name "\t \t \t "
    should_reject_signee_name "\n\n\n"
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

def should_reject_signee_name(name)
  signatories_before = Signatory.all.size
  post '/signatories', params={:name => name}
  follow_redirect!
  Signatory.all.size.should == signatories_before
  last_response.body.should have_selector(".error")
end

def should_accept_signee_name(name)
  signatories_before = Signatory.all.size
  post '/signatories', params={:name => name}
  follow_redirect!
  Signatory.all.size.should == signatories_before + 1
  last_response.body.should_not have_selector(".error")
end
