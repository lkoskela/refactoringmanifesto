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

