require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'erb'
require "dm-core"
require 'dm-migrations'

require File.join(File.dirname(__FILE__), 'db', 'config.rb')

model_dir = File.join(File.dirname(__FILE__), 'lib', 'model')
Dir.glob("#{model_dir}/*.rb") do |file|
  require file
  model_class = File.basename(file).gsub("\.rb", "").capitalize
  model_class = Kernel.eval(model_class)
  model_class.auto_migrate! unless model_class.storage_exists?
end

require File.join(File.dirname(__FILE__), 'lib', 'manifesto.rb')
require File.join(File.dirname(__FILE__), 'lib', 'authentication.rb')
require File.join(File.dirname(__FILE__), 'lib', 'routes', 'routes.rb')

mime_type :ttf, "application/octet-stream"
mime_type :woff, "application/octet-stream"
