require 'test_helper'

module Orchestrator
  class ListenForAnalyzersToDeployTest < Minitest::Test

    def test_proxies_message_correctly
      image_name = "exercism-analyzer-ruby:v1.20.0"
      message = {image_name: image_name}
      propono_client = mock
      propono_client.expects(:listen).with(:analyzer_ready_to_deploy).yields(message)
      Propono.expects(:configure_client).returns(propono_client)

      DeployAnalyzer.expects(:call).with(image_name)
      ListenForAnalyzersToDeploy.()
    end
  end
end

