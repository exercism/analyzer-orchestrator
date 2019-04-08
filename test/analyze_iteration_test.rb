require 'test_helper'

module Orchestrator
  class AnalyzeIterationTest < Minitest::Test

    def test_calls_system_and_propono_with_the_correct_params_and
      iteration_id = SecureRandom.uuid
      s3_url = "s3://exercism-iterations/test/iterations/#{iteration_id}"

      Kernel.expects(:system).with(%Q{analyse_iteration ruby two-fer #{s3_url}})
      Orchestrator::AnalyzeIteration.("ruby", "two-fer", iteration_id)
    end

    def test_fails_with_invalid_analyzers
      Kernel.expects(:system).never
      Orchestrator::AnalyzeIteration.("ruby", "foobar", SecureRandom.uuid)
      Orchestrator::AnalyzeIteration.("foobar", "two-fer", SecureRandom.uuid)
    end
  end
end

