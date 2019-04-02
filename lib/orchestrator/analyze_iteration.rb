module Orchestrator
  class AnalyzeIteration
    include Mandate

    initialize_with :track_slug, :exercise_slug, :iteration_id

    def call
      cmd = %Q{analyse_iteration #{track_slug} #{exercise_slug} #{s3_url}}
      if Kernel.system(cmd)
        # TODO: Handle success
      else
        # TODO: Handle failure
      end
    end

    private

    def s3_url
      "s3://#{s3_bucket}/#{env}/iterations/#{iteration_id}"
    end

    def env
      ENV["env"] || "development"
    end

    def s3_bucket
      creds = YAML::load(ERB.new(File.read(File.dirname(__FILE__) + "/../../config/secrets.yml")).result)[env]
      creds['aws_iterations_bucket']
    end
  end
end

