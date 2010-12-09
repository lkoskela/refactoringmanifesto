require File.dirname(__FILE__) + '/spec_helper'
require 'encoding/character/utf-8'

describe "The Refactoring Manifesto" do
  include Rack::Test::Methods
  def app; @app ||= Sinatra::Application ; end

  before(:all) do
  end

  after(:all) do
  end

  before(:each) do
  end

  after(:each) do
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should respond with 404 to incorrect URLs" do
    get '/no/such/url/here'
    last_response.status.should == 404
  end

  it "should list all of the statements from manifesto.yml" do
    get '/'
    manifesto = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'lib', 'manifesto.yml'))
    manifesto.each do |c|
      heading = u c['commandment']
      explanation = u c['explanation']
      last_response.body.should include heading
      last_response.body.should include explanation
    end
  end

  it "should mention the number of signatories to date" do
    quoted_signatories_to_date_should_be 0
    sign_up "John Doe"
    quoted_signatories_to_date_should_be 1
    sign_up "Jane Doe", "Jim Doe"
    quoted_signatories_to_date_should_be 3
  end
end

def sign_up(*names)
  names.each do |name|
    Signatory.create(:name => name, :created_at => DateTime.now)
  end
end

def quoted_signatories_to_date_should_be(expected_number)
  get '/'
  last_response.body.should include "total of #{expected_number} people"
end
