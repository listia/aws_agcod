require "aws_agcod/version"
require "aws_agcod/config"
require "aws_agcod/create_gift_card"
require "aws_agcod/cancel_gift_card"
require "aws_agcod/gift_card_activity_list"

module AGCOD
  def self.configure(&block)
    @config = Config.new

    yield @config

    nil
  end

  def self.config
    @config
  end
end
