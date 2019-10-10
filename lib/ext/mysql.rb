require 'yaml'
require 'erb'

module Mysql2
  def self.configure_client
    creds = YAML::load(ERB.new(File.read(File.dirname(__FILE__) + "/../../config/secrets.yml")).result)
    creds = creds[ ENV["env"] || "development" ]

    Mysql2::Client.new(
      host: creds['mysql_host'],
      username: creds['mysql_username'],
      password: creds['mysql_password'],
      database: creds['mysql_database'],
      encoding: "utf8mb4",
      collation: "utf8mb4_unicode_ci"
    )
  end
end
