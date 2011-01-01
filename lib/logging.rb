module Log
  def self.info(msg)
    open("application.log", "a+") do |f|
      f << "[INFO] " << msg << "\n"
    end
  end
end