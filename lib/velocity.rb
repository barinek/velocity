$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'pivotal-tracker'
require 'dalli'
require 'haml'

require "velocity/version"

module Velocity
  require "velocity/handler"
  require "velocity/harvester"
end
