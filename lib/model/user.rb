require "dm-core"
require 'digest/sha1'

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String, :key => true
  property :passwd, String
  
  def self.register(username, password)
    User.create(:username => username, :passwd => self.mangle(password))
  end
  
  def authenticate(password)
    Log.info "Trying to authenticate user '#{username}' with password '#{password}'"
    @has_been_authenticated = (password == self.passwd)
    @has_been_authenticated
  end
  
  def authenticated?
    @has_been_authenticated ||= false
  end
  
  def self.mangle(password)
    hash = Digest::SHA1.new
    hash.update(password)
    hash.hexdigest
  end
end