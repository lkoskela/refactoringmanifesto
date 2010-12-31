require "dm-core"

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String, :key => true
  property :passwd, String
  
  def self.register(username, password)
    User.create(:username => username, :passwd => self.mangle(password))
  end
  
  def authenticate(password)
    User.mangle(password) == self.passwd
  end
  
  def self.mangle(password)
    password.reverse
  end
end