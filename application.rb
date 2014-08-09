require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'rack-flash'
require 'erb'
require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

require File.join(File.dirname(__FILE__), 'db', 'config.rb')
require File.join(File.dirname(__FILE__), 'lib', 'sha1.rb')

model_dir = File.join(File.dirname(__FILE__), 'lib', 'model')
Dir.glob("#{model_dir}/*.rb") do |file|
  require file
  model_class = File.basename(file).gsub("\.rb", "").capitalize
  model_class = Kernel.eval(model_class)
  model_class.auto_migrate! unless model_class.storage_exists?
end
DataMapper.finalize

require File.join(File.dirname(__FILE__), 'lib', 'logging.rb')
require File.join(File.dirname(__FILE__), 'lib', 'manifesto.rb')
require File.join(File.dirname(__FILE__), 'lib', 'authentication.rb')
require File.join(File.dirname(__FILE__), 'lib', 'routes', 'routes.rb')

mime_type :otf, "application/octet-stream"
mime_type :ttf, "application/octet-stream"
mime_type :woff, "application/x-woff"
mime_type :eot, "application/vnd.ms-fontobject"
mime_type :svg, "image/svg+xml"
