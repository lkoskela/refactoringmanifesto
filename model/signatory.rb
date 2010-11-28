require "dm-core"

class Signatory
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :created_at, DateTime
end