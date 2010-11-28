ENV['RACK_ENV'] = 'test'
require File.join(File.dirname(__FILE__), '..', 'application.rb')

require 'rubygems'
require 'bundler'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'rspec/autorun'

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

