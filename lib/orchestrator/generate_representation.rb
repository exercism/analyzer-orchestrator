module Orchestrator
  class GenerateRepresentation
    include Mandate

    initialize_with :track_slug, :exercise_slug, :iteration_id

    def call
      invoke_generator!
      representation
    end

    private

    def invoke_generator!
      case env
      when "development"
        Bundler.with_clean_env do
          cmd = %Q{cd ../representer-dev-invoker && bin/run.sh #{s3_path} #{data_path}}
          p "Running: #{cmd}"
          Kernel.system(cmd)
        end
      else
        cmd = %Q{generate_representation #{track_slug} #{exercise_slug} #{s3_url} #{system_identifier}}
        p "Running: #{cmd}"
        Kernel.system(cmd)
      end
    end

    memoize
    def cmd
    end

    memoize
    def system_identifier
      "#{Time.now.to_i}_#{iteration_id}"
    end

    def s3_url
      "s3://#{s3_bucket}/#{s3_path}"
    end

    def s3_path
      "#{env}/iterations/#{iteration_id}"
    end

    def env
      ENV["env"] || "development"
    end

    def s3_bucket
      creds = YAML::load(ERB.new(File.read(File.dirname(__FILE__) + "/../../config/secrets.yml")).result)[env]
      creds['aws_iterations_bucket']
    end

    def representation
      #location = "#{data_path}/iteration/output/representation.txt"
      location = "#{data_path}/iteration/input/representation.txt"
      p "looking for representation.txt in #{location}"
      r = File.read(location)
      p "File read successfully"
      r
    rescue
      p "Could not read file from there"
      nil
    end

    def data_path
      "#{data_root_path}/#{track_slug}/runs/iteration_#{system_identifier}/iteration"
    end

    def data_root_path
      case env
      when "production"
        PRODUCTION_DATA_PATH
      else
        File.expand_path(File.dirname(__FILE__) + "/../../tmp/representer/").tap do |path|
          FileUtils.mkdir_p(path)
        end
      end
    end

    PRODUCTION_DATA_PATH = "/opt/exercism/representation_runtime".freeze
    private_constant :PRODUCTION_DATA_PATH
  end
end
