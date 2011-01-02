require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :spec do
  desc "Run RSpec code examples with RCov for code coverage"
  RSpec::Core::RakeTask.new('rcov' ) do |t|
    t.rcov = true
    t.rcov_opts = ['--exclude' , '\/Library\/Ruby', '--output', 'tmp/coverage']
  end
end

namespace :db do
  desc "Register an admin user (rake db:register_user USERNAME=admin PASSWORD=secret RACK_ENV=production)"
  task :register_user do |t|
    require './application.rb'
    User.register(ENV['USERNAME'], ENV['PASSWORD'])
  end
end
