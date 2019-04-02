require 'test_helper'

module Orchestrator
  class DeployAnalyzerTest < Minitest::Test

    def test_calls_system
      track_slug = "ruby"
      image_name = "ruby-analyzer:v1.2.3"

      Kernel.expects(:system).with(%Q{release_analyzer ruby ruby-analyzer:v1.2.3})
      Orchestrator::DeployAnalyzer.(track_slug, image_name)
    end
  end
end

