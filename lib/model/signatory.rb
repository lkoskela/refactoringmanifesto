require "dm-core"

class Signatory
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :created_at, DateTime
  
  validates_uniqueness_of :name
  validates_length_of :name, :min => 4
  validates_with_method :check_whitespace
  
  def check_whitespace
    return true if self.name.strip.length >= 3
    [false, "Nobody's name is all whitespace..."]
  end
end
