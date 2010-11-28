require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'erb'
require "dm-core"
require 'dm-migrations'

require File.join(File.dirname(__FILE__), 'db', 'config.rb')
require File.join(File.dirname(__FILE__), 'lib/manifesto.rb')
['Signatory'].each do |model_class|
  model_path = File.join(File.dirname(__FILE__), 'model', "#{model_class.downcase}.rb")
  puts "Loading model #{model_class} from #{model_path}..."
  require model_path
  model_class = Kernel.eval(model_class)
  model_class.auto_migrate! unless model_class.storage_exists?
end

#DataMapper.setup(:default, "sqlite3://#{File.join(Dir.pwd, 'db/production.db')}")
#configure :test do
#  DataMapper.setup(:default, "sqlite3::memory:")
#  DataMapper.auto_migrate!
#end
#configure :development do
#  DataMapper.setup(:default, "sqlite3://#{File.join(Dir.pwd, 'db/development.db')}")
#end
#DataMapper.finalize
#Signatory.auto_migrate! unless Signatory.storage_exists?

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
