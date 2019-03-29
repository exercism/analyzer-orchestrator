module Orchestrator
  class ListenForAnalyzersToDeploy
    include Mandate

    def call
      client.listen(:analyzer_ready_to_deploy) do |message|
        image_name = message[:image_name]
        DeployAnalyzer.(image_name)
      end
    end

    private
    def client
      @client ||= Propono.configure_client
    end
  end
end

