module Orchestrator
  class DeployAnalyzer
    include Mandate

    initialize_with :track_slug, :image_name

    def call
      cmd = %Q{release_analyzer #{track_slug} #{image_name}}
      Kernel.system(cmd)
    end
  end
end
