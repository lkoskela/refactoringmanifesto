module Manifesto
  def self.commandments
    manifesto_source = File.join(File.dirname(__FILE__), 'manifesto.yml')
    puts "Loading manifesto from #{manifesto_source}"
    YAML.load_file(manifesto_source)
  end
end