require 'test_helper'

module Orchestrator
  class ListenForAnalyzersToDeployTest < Minitest::Test

    def test_proxies_message_correctly
      track_slug = "ruby"
      image_name = "exercism-analyzer-ruby:v1.20.0"
      message = {track_slug: track_slug, image_name: image_name}
      propono_client = mock
      propono_client.expects(:listen).with(:representation__analyzer_ready_to_deploy).yields(message)
      Propono.expects(:configure_client).returns(propono_client)

      DeployAnalyzer.expects(:call).with(track_slug, image_name)
      ListenForAnalyzersToDeploy.()
    end
  end
end

