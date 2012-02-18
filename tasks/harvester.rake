require 'velocity'

namespace :harvester do
  task :harvest do
    puts "[harvester] starting harvest."
    Harvester.harvest
    puts "[harvester] finished harvest."
  end

  task :find_projects do
    Harvester.find_projects.each do |project|
      puts project
    end
  end

  task :clear_projects do
    Harvester.clear_projects
  end
end
