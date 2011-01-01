ENV['RACK_ENV'] = 'test'
require File.join(File.dirname(__FILE__), '..', 'application.rb')

require 'rubygems'
require 'bundler'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'rspec/autorun'
require 'webrat'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

RSpec.configure do |config|
  config.before(:all) {}
  config.before(:each) {
    DataMapper.setup(:default, "sqlite3::memory:")
    DataMapper.auto_migrate!
  }
  config.after(:all) {}
  config.after(:each) {}
end

# environment tests

describe "Runtime environment" do
  it "should be Ruby 1.9" do
    RUBY_VERSION.should =~ /^1\.9/
  end
end

# define helper methods (typically assertions)

def should_have_redirected_to(regex)
  last_response.redirect?.should == true
  last_response.location.should =~ regex
end

def quoted_signatories_to_date_should_be(expected_number)
  get '/signatories'
  last_response.body.should include "total of #{expected_number} people"
  Signatory.all.size.should == expected_number
end
