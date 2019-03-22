require 'yaml'
require 'erb'

module Propono
  def self.configure_client
    Client.new do |config|
      creds = YAML::load(ERB.new(File.read(File.dirname(__FILE__) + "/../../config/propono.yml.erb")).result)

      creds = creds["development"]

      config.access_key = creds["access_key"]
      config.secret_key = creds["secret_key"]
      config.queue_region = creds["queue_region"]
      config.queue_suffix = creds["queue_suffix"] || ""
      config.application_name = creds["application_name"]
      # config.logger = Rails.logger
    end
  end
end
