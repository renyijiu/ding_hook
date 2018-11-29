require "ding_hook/version"
require "ding_hook/config"
require "ding_hook/exception"
require "ding_hook/message"

module DingHook
  class << self
    def configure
      config = DingHook::Config.instance

      hash = yield({})
      config.configuration(hash)
    end

    def config
      DingHook::Config.instance.configuration
    end



  end
end
