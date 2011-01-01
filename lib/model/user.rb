require "dm-core"
require 'sha1'

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String, :key => true
  property :passwd, String
  
  def self.register(username, password)
    User.create(:username => username, :passwd => SHA1.hash(password))
  end
  
  def authenticate(password)
    Log.info "Trying to authenticate user '#{username}' with password '#{password}'"
    @has_been_authenticated = (password == self.passwd)
    @has_been_authenticated
  end
  
  def authenticated?
    @has_been_authenticated ||= false
  end
end