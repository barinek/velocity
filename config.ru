GEMSPEC = eval(File.read(File.expand_path('../velocity.gemspec', __FILE__)))

require 'rubygems'
require 'velocity'

use Rack::Auth::Basic, "Velocity" do |username, password|
  [username, password] == ['user', ENV['USER_PASSWORD']]
end

run Handler.new
