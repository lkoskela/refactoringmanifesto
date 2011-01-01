module SHA1
  def self.hash(data)
    h = Digest::SHA1.new
    h.update(data)
    h.hexdigest
  end
end