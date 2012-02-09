require "bundler/gem_tasks"
import  *Dir['tasks/*.rake']

GEMSPEC = eval(File.read(File.expand_path('../velocity.gemspec', __FILE__)))

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.pattern = 'test/**/test_*.rb'
  t.warning = true
end

task :default => [:test]

