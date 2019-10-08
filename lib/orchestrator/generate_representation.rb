module Orchestrator
  class GenerateRepresentation
    include Mandate

    initialize_with :track_slug, :exercise_slug, :iteration_id

    def call
      p "Running #{cmd}"
      Kernel.system(cmd)
      representation
    end

    private

    memoize
    def cmd
      %Q{generate_representation #{track_slug} #{exercise_slug} #{s3_url} #{system_identifier}}
    end

    memoize
    def system_identifier
      "#{Time.now.to_i}_#{iteration_id}"
    end

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

    def representation
      location = "#{data_root_path}/#{track_slug}/runs/iteration_#{system_identifier}/iteration/representation.txt"
      File.read(location)
    rescue
      nil
    end

    def data_root_path
      case env
      when "production"
        PRODUCTION_DATA_PATH
      else
        File.expand_path(File.dirname(__FILE__) + "/../../tmp/representation_runtime/").tap do |path|
          FileUtils.mkdir_p(path)
        end
      end
    end

    PRODUCTION_DATA_PATH = "/opt/exercism/representation_runtime".freeze
    private_constant :PRODUCTION_DATA_PATH
  end
end
