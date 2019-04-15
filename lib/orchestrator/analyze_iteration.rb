module Orchestrator

  VALID_ANALYZERS = [
    ['ruby', 'two-fer'],
    ['csharp', 'two-fer']
  ]

  class AnalyzeIteration
    include Mandate

    initialize_with :track_slug, :exercise_slug, :iteration_id

    def call
      return unless VALID_ANALYZERS.include?([track_slug, exercise_slug])

      cmd = %Q{analyse_iteration #{track_slug} #{exercise_slug} #{s3_url}}
      p "Running #{cmd}"

      if Kernel.system(cmd)
        propono.publish(:iteration_analyzed, {
          iteration_id: iteration_id,
          status: :success
        })
        # TODO: Handle success
      else
        # TODO: Handle failure
        propono.publish( :iteration_analyzed, {
          iteration_id: iteration_id,
          status: :failure
        })
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

    memoize
    def propono
      Propono.configure_client
    end
  end
end

