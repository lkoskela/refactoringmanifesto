module Authentication
  class UnknownUser < User
    def authenticate(password); false; end
  end
  
  def self.authenticate(username, password)
    user = User.first(:username => username) || UnknownUser.new
    return user if user.authenticate(password)
    nil
  end
end
