require 'test_helper'
require 'json'

module Orchestrator
  class AnalyzeIterationTest < Minitest::Test

    def test_calls_system_and_propono_with_the_correct_params
      Timecop.freeze do
        iteration_id = SecureRandom.uuid
        analysis = {"foo" => "bar"}

        s3_url = "s3://exercism-iterations/test/iterations/#{iteration_id}"

        data_path = File.expand_path(File.dirname(__FILE__) + "/../tmp/analysis_runtime/ruby/runs/iteration_#{Time.now.to_i}_#{iteration_id}/iteration/")
        FileUtils.mkdir_p(data_path)
        File.open(data_path + "/analysis.json", "w") { |f| f << analysis.to_json }

        propono = mock
        propono.expects(:publish).with(:iteration_analyzed, {
          iteration_id: iteration_id,
          status: :success,
          analysis: analysis
        })
        Propono.expects(:configure_client).returns(propono)

        Kernel.expects(:system).with(%Q{analyse_iteration ruby two-fer #{s3_url} #{Time.now.to_i}_#{iteration_id}}).returns(true)
        Orchestrator::AnalyzeIteration.("ruby", "two-fer", iteration_id)
      end
    end

    def test_calls_system_and_propono_with_the_correct_params_when_fails
      Timecop.freeze do
        iteration_id = SecureRandom.uuid
        s3_url = "s3://exercism-iterations/test/iterations/#{iteration_id}"

        propono = mock
        propono.expects(:publish).with(:iteration_analyzed, {
          iteration_id: iteration_id,
          status: :fail
        })
        Propono.expects(:configure_client).returns(propono)

        Kernel.expects(:system).with(%Q{analyse_iteration ruby two-fer #{s3_url} #{Time.now.to_i}_#{iteration_id}}).returns(false)
        Orchestrator::AnalyzeIteration.("ruby", "two-fer", iteration_id)
      end
    end

    def test_fails_with_invalid_analyzers
      Kernel.expects(:system).never
      Orchestrator::AnalyzeIteration.("ruby", "foobar", SecureRandom.uuid)
      Orchestrator::AnalyzeIteration.("foobar", "two-fer", SecureRandom.uuid)
    end
  end
end

