require "aws_agcod/version"
require "aws_agcod/create_gift_card"
require "aws_agcod/cancel_gift_card"

module AwsAgcod
  ROOT_PATH = if defined?(Rails)
    Rails.root
  else
    Pathname.new(__FILE__).join("../..").expand_path
  end

  def self.env
    if defined?(Rails)
      Rails.env
    else
      @enviroment || "development"
    end
  end

  def self.env=(enviroment)
    @enviroment = enviroment
  end

  def self.config_file
    @config_file || ROOT_PATH.join("config/agcod.yml")
  end

  def self.config_file=(file_path)
    if ROOT_PATH.join(file_path).exist?
      @config_file = ROOT_PATH.join(file_path)
    end
  end
end
