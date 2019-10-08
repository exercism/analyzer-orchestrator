require 'test_helper'
require 'json'

module Orchestrator
  class GenerateRepresentationTest < Minitest::Test

    def test_calls_system_and_propono_with_the_correct_params
      Timecop.freeze do
        iteration_id = SecureRandom.uuid
        representation = "defn(foobar, (...))"

        s3_url = "s3://test-exercism-iterations/test/iterations/#{iteration_id}"

        data_path = File.expand_path(File.dirname(__FILE__) + "/../tmp/representation_runtime/ruby/runs/iteration_#{Time.now.to_i}_#{iteration_id}/iteration/")
        FileUtils.mkdir_p(data_path)
        File.open(data_path + "/representation.txt", "w") { |f| f << representation }

        Kernel.expects(:system).with(%Q{generate_representation ruby two-fer #{s3_url} #{Time.now.to_i}_#{iteration_id}}).returns(true)
        actual = Orchestrator::GenerateRepresentation.("ruby", "two-fer", iteration_id)
        assert_equal representation, actual
      end
    end

    def test_calls_system_and_propono_with_the_correct_params_when_fails
      Timecop.freeze do
        iteration_id = SecureRandom.uuid
        s3_url = "s3://test-exercism-iterations/test/iterations/#{iteration_id}"

        Kernel.expects(:system).with(%Q{generate_representation ruby two-fer #{s3_url} #{Time.now.to_i}_#{iteration_id}}).returns(false)
        assert_nil Orchestrator::GenerateRepresentation.("ruby", "two-fer", iteration_id)
      end
    end
  end
end
