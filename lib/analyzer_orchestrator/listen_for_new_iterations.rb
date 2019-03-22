module AnalyzerOrchestrator
  class ListenForNewIterations
    include Mandate

    def call
      client.listen(:new_iteration) do |message|
        track_slug = message[:track_slug]
        iteration_id = message[:id]
        p "Fire analyzer for #{track_slug} for Iteration##{iteration_id}"
      end
    end

    private
    def client
      @client ||= Propono.configure_client
    end
  end
end
