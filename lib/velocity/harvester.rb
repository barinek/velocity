class Harvester
  def self.harvest
    PivotalTracker::Client.token = ENV['TRACKER_API_TOKEN']
    PivotalTracker::Client.use_ssl = true

    tracker_project_ids_string = ENV['TRACKER_PROJECT_IDS']
    tracker_project_ids = []
    tracker_project_ids = tracker_project_ids_string.split(",") unless tracker_project_ids_string.nil?

    projects = []
    tracker_project_ids.each do |project_id|
      puts "[harvester] harvesting project_id #{project_id}"

      project = PivotalTracker::Project.find(project_id.to_i)
      iterations = determine_recent_points(project)
      points = iterations.values[0..9]
      stdev = points.size > 0 ? standard_deviation(points) : 0
      points = ([].fill(0, 0..(9-points.size)))+points if points.size < 10

      points = points.each.collect { |p| (p+1).to_s }
      the_hash = {:name => project.name,
                  :current_velocity => project.current_velocity,
                  :initial_velocity => project.initial_velocity,
                  :recent_velocities => points.join(","),
                  :stdev => stdev}

      puts "[harvester] harvested #{the_hash}"
      projects.push the_hash
    end

    sorted_projects = projects.sort! { |a, b| a[:name].downcase <=> b[:name].downcase }

    dalli_client = Dalli::Client.new
    dalli_client.set("projects", sorted_projects)
    projects
  end

  def self.find_projects
    dalli_client = Dalli::Client.new
    projects = dalli_client.get("projects")

    if projects.nil?
      projects = [{:name=>"Example Project", :current_velocity=>8, :initial_velocity=>10, :recent_velocities=>"7,9,13,13,12,11,11,7,7,13", :stdev=>2.4515301344262523}]
    end

    projects
  end

  def self.clear_projects
    dalli_client = Dalli::Client.new
    dalli_client.set("projects", nil)
  end

  private

  def self.determine_recent_points(project)
    iterations = {}
    PivotalTracker::Iteration.done(project, :offset => -10).each_with_index do |iteration, index|
      iterations[index] = 0
      iteration.stories.each do |story|
        if story.story_type.eql?("feature") && story.current_state.eql?("accepted")
          iterations[index]+= story.estimate
        end
      end
    end
    iterations
  end

  def self.variance(population)
    n = 0
    mean = 0.0
    s = 0.0
    population.each { |x|
      n = n + 1
      delta = x - mean
      mean = mean + (delta / n)
      s = s + delta * (x - mean)
    }
    # if you want to calculate std deviation
    # of a sample change this to "s / (n-1)"
    s / n
  end

  # calculate the standard deviation of a population
  # accepts: an array, the population
  # returns: the standard deviation
  def self.standard_deviation(population)
    Math.sqrt(variance(population))
  end

end