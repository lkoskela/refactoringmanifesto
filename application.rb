require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'erb'
require "dm-core"
require 'dm-migrations'

require File.join(File.dirname(__FILE__), 'lib/manifesto.rb')
require File.join(File.dirname(__FILE__), 'lib/signatory.rb')

DataMapper.setup(:default, "sqlite3://#{File.join(Dir.pwd, 'db/manifesto.db')}")
configure :test do
  DataMapper.setup(:default, "sqlite3::memory:")
end

DataMapper.finalize
Signatory.auto_migrate! unless Signatory.storage_exists?

get '/' do
  @number_of_signatories = Signatory.count
  @manifesto = Manifesto.commandments
  erb :manifesto
end

get '/signatories' do
  @signatories = Signatory.all(:order => [ :created_at.desc ])
  erb :signatories
end

post '/signatories' do
  new_signatory = Signatory.new(:name => params['name'], :created_at => DateTime.now)
  new_signatory.save
  @added = new_signatory.name
  @signatories = Signatory.all(:order => [ :created_at.desc ])
  erb :signatories
end
