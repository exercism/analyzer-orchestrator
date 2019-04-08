require 'test_helper'

module Orchestrator
  class AnalyzeIterationTest < Minitest::Test

    def test_calls_system_and_propono_with_the_correct_params
      iteration_id = SecureRandom.uuid
      s3_url = "s3://exercism-iterations/test/iterations/#{iteration_id}"

      propono = mock
      propono.expects(:publish).with(:iteration_analyzed, {
        iteration_id: iteration_id,
        status: :success
      })
      Propono.expects(:configure_client).returns(propono)

      Kernel.expects(:system).with(%Q{analyse_iteration ruby two-fer #{s3_url}}).returns(true)
      Orchestrator::AnalyzeIteration.("ruby", "two-fer", iteration_id)
    end

    def test_calls_system_and_propono_with_the_correct_params_when_fails
      iteration_id = SecureRandom.uuid
      s3_url = "s3://exercism-iterations/test/iterations/#{iteration_id}"

      propono = mock
      propono.expects(:publish).with(:iteration_analyzed, {
        iteration_id: iteration_id,
        status: :failure
      })
      Propono.expects(:configure_client).returns(propono)

      Kernel.expects(:system).with(%Q{analyse_iteration ruby two-fer #{s3_url}}).returns(false)
      Orchestrator::AnalyzeIteration.("ruby", "two-fer", iteration_id)
    end



    def test_fails_with_invalid_analyzers
      Kernel.expects(:system).never
      Orchestrator::AnalyzeIteration.("ruby", "foobar", SecureRandom.uuid)
      Orchestrator::AnalyzeIteration.("foobar", "two-fer", SecureRandom.uuid)
    end
  end
end

