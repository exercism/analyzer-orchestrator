require 'test_helper'
require 'json'

module Orchestrator
  class CheckIterationTest < Minitest::Test

    def test_valid_analysis_with_propono
      iteration_id = mock
      analysis = {"foo" => "bar"}

      propono = mock
      propono.expects(:publish).with(:iteration_representation_analyzed, {
        iteration_id: iteration_id,
        status: :success,
        analysis: analysis
      })
      Propono.expects(:configure_client).returns(propono)
      CheckRepresentation.expects(:call).returns(nil)
      AnalyzeIteration.expects(:call).returns(analysis)

      Orchestrator::CheckIteration.("ruby", "two-fer", iteration_id)
    end

    def test_failed_analysis_with_propono
      iteration_id = mock

      propono = mock
      propono.expects(:publish).with(:iteration_representation_analyzed, {
        iteration_id: iteration_id,
        status: :fail
      })
      Propono.expects(:configure_client).returns(propono)

      CheckRepresentation.expects(:call).returns(nil)
      AnalyzeIteration.expects(:call).returns(nil)
      Orchestrator::CheckIteration.("ruby", "two-fer", iteration_id)
    end
  end
end
