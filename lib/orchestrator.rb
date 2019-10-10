require "mandate"
require "propono"
require "mysql2"

require "ext/propono"
require "ext/mysql"
require "orchestrator/generate_representation"
require "orchestrator/check_representation"
require "orchestrator/analyzers"
require "orchestrator/analyze_iteration"
require "orchestrator/check_iteration"

require "orchestrator/deploy_analyzer"
require "orchestrator/publish_message"
require "orchestrator/listen_for_new_iterations"
require "orchestrator/listen_for_analyzers_to_deploy"

module Orchestrator
  def self.listen
    t1 = Thread.new { ListenForNewIterations.() }
    t2 = Thread.new { ListenForAnalyzersToDeploy.() }
    [t1, t2].each(&:join)
  end
end
