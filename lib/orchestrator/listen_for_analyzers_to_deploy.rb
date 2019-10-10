module Orchestrator
  class ListenForAnalyzersToDeploy
    include Mandate

    def call
      client.listen(:representation__analyzer_ready_to_deploy) do |message|
        track_slug = message[:track_slug]
        image_name = message[:image_name]
        DeployAnalyzer.(track_slug, image_name)
      end
    end

    private
    def client
      @client ||= Propono.configure_client
    end
  end
end

