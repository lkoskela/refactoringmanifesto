configure :production do
  DataMapper.setup(:default, "sqlite3://#{File.join(Dir.pwd, 'db/production.db')}")
end

configure :test do
  DataMapper.setup(:default, "sqlite3::memory:")
  DataMapper.auto_migrate!
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{File.join(Dir.pwd, 'db/development.db')}")
  DataMapper.auto_migrate!
end
