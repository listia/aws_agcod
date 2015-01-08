require "aws_agcod/version"
require "pathname"

module AwsAgcod
  ROOT_PATH = Pathname.new(__FILE__).join("../..").expand_path

  def self.env
    if defined?(Rails)
      Rails.env
    else
      @@enviroment || "development"
    end
  end

  def self.env=(enviroment)
    @@enviroment = enviroment
  end

  def self.config_file
    @@config_file || ROOT_PATH.root.join("config/agcod.yml")
  end

  def self.config_file=(file_path)
    if ROOT_PATH.root.join(file_path).exist?
      @@config_file = ROOT_PATH.root.join(file_path)
    end
  end
end
