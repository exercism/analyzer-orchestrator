module Orchestrator
  class DeployAnalyzer
    include Mandate

    initialize_with :image_name

    def call
      cmd = %Q{echo "Deploy analyzer #{image_name}"}
      Kernel.system(cmd)
    end
  end
end
