require 'rubygems'
require 'sinatra'

set :env, :production
disable :run
set :dump_errors, true
set :raise_errors, true
set :views, 'views'
set :logging, true

#log = File.new("sinatra.log", "a+")
#STDOUT.reopen(log)
#STDERR.reopen(log)

require './application'

run Sinatra::Application

