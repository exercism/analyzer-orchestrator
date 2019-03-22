require "mandate"
require "propono"

require "ext/propono"
require "analyzer_orchestrator/publish_message"
require "analyzer_orchestrator/listen_for_new_iterations"

module AnalyzerOrchestrator
  def self.listen
    ListenForNewIterations.()
  end
end
