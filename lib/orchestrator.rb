require "mandate"
require "propono"

require "ext/propono"
require "orchestrator/analyze_iteration"
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
