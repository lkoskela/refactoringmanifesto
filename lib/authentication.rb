module Authentication
  class UnknownUser < User
    def authenticate(password); false; end
    def authenticated?; false; end
  end
  
  def self.authenticate(username, password, &block)
    user = User.first(:username => username) || UnknownUser.new
    return user if user.authenticate(password)
    if block_given?
      if user.is_a? UnknownUser
        yield "No such user: #{username}"
      else
        yield "Wrong password for #{username}"
      end
    end
    return user
  end
end
