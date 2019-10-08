require 'test_helper'
require 'json'

module Orchestrator
  class AnalyzeIterationTest < Minitest::Test

    def test_calls_system_and_propono_with_the_correct_params
      Timecop.freeze do
        iteration_id = SecureRandom.uuid
        analysis = {"foo" => "bar"}

        s3_url = "s3://test-exercism-iterations/test/iterations/#{iteration_id}"

        data_path = File.expand_path(File.dirname(__FILE__) + "/../tmp/analysis_runtime/ruby/runs/iteration_#{Time.now.to_i}_#{iteration_id}/iteration/")
        FileUtils.mkdir_p(data_path)
        File.open(data_path + "/analysis.json", "w") { |f| f << analysis.to_json }

        Kernel.expects(:system).with(%Q{analyse_iteration ruby two-fer #{s3_url} #{Time.now.to_i}_#{iteration_id}}).returns(true)
        actual = Orchestrator::AnalyzeIteration.("ruby", "two-fer", iteration_id, nil)
        assert_equal analysis, actual
      end
    end

    def test_calls_system_and_propono_with_the_correct_params_when_fails
      Timecop.freeze do
        iteration_id = SecureRandom.uuid
        s3_url = "s3://test-exercism-iterations/test/iterations/#{iteration_id}"
        representation_results = mock

        Kernel.expects(:system).with(%Q{analyse_iteration ruby two-fer #{s3_url} #{Time.now.to_i}_#{iteration_id}}).returns(false)
        assert_equal(representation_results, Orchestrator::AnalyzeIteration.("ruby", "two-fer", iteration_id, representation_results))
      end
    end

    def test_fails_with_invalid_analyzers
      iteration_id = SecureRandom.uuid
      representation_results = mock

      Kernel.expects(:system).never

      assert_equal(representation_results, Orchestrator::AnalyzeIteration.("ruby", "foobar", iteration_id, representation_results))
    end
  end
end

