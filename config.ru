require 'rubygems'
require 'sinatra'

set :env, :production
disable :run
set :raise_errors, true
set :views, 'views'

log = File.new("sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'application'

run Sinatra::Application