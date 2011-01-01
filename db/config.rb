def log(msg)
    open("application.log", "a+") do |f|
      f << "[CONFIG] " << msg << "\n"
    end
end

configure :production do
  log "PRODUCTION"
  DataMapper.setup(:default, "sqlite3://#{File.join(Dir.pwd, 'db/production.db')}")
end

configure :test do
  DataMapper.setup(:default, "sqlite3::memory:")
  DataMapper.auto_migrate!
end

configure :development do
  log "DEVELOPMENT"
  DataMapper.setup(:default, "sqlite3://#{File.join(Dir.pwd, 'db/development.db')}")
  DataMapper.auto_migrate!
end
