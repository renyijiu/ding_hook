require "ding_hook/version"
require "ding_hook/config"
require "ding_hook/exception"
require "ding_hook/valid"
require "ding_hook/message"

module DingHook

  class << self
    def configure
      config_hash = {}
      yield(config_hash)

      config = DingHook::Config.instance
      config.configuration(config_hash)
    end

    def config
      DingHook::Config.instance.configuration
    end

    def send_msg(params, type = :text, accounts = [:default])
      accounts = accounts.is_a?(::Array) ? accounts : [accounts]

      res = []
      ding = DingHook::Message.new

      accounts.each do |account|
        res << ding.send_msg(params,account.to_sym, type.to_sym)
      end

      res.inject([true, '']) {|result, arr| [result.first && arr.first, result.last + arr.last]}
    end

  end
end
