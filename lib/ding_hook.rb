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
      ding = DingHook::Message.new

      ding.send_msg(params, accounts, type.to_sym)
    end

    def send_text_msg(text, options = {}, accounts = [:default])
      params = {
          text: text,
          at_mobiles: options.fetch(:at_mobiles, []),
          is_at_all: options.fetch(:is_at_all, false)
      }

      DingHook::Message.new.send_msg(params, accounts, :text)
    end

    def send_link_msg(title, text, msg_url, options = {}, accounts = [:default])
      params = {
          text: text,
          title: title,
          message_url: msg_url,
          pic_url: options.fetch(:pic_url, nil)
      }

      DingHook::Message.new.send_msg(params, accounts, :link)
    end

    def send_markdown_msg(title, text, options = {}, accounts = [:default])
      params = {
          text: text,
          title: title,
          at_mobiles: options.fetch(:at_mobiles, []),
          is_at_all: options.fetch(:is_at_all, false)
      }

      DingHook::Message.new.send_msg(params, accounts, :markdown)
    end

    def send_single_action_card(title, text, single_title, single_url, options = {}, accounts = [:default])
      params = {
          title: title,
          text: text,
          single_title: single_title,
          single_url: single_url,
          btn_orientation: options.fetch(:btn_orientation, nil),
          hide_avator: options.fetch(:hide_avator, nil)
      }

      DingHook::Message.new.send_msg(params, accounts, :action_card)
    end

    def send_btns_action_card(title, text, btns, options = {}, accounts = [:default])
      btns = btns.is_a?(Array) ? btns : [btns]
      params = {
          title: title,
          text: text,
          btns: btns,
          btn_orientation: options.fetch(:btn_orientation, nil),
          hide_avator: options.fetch(:hide_avator, nil)
      }

      DingHook::Message.new.send_msg(params, accounts, :action_card)
    end

    def send_feed_card(links, accounts = [:default])
      links = links.is_a?(Array) ? links : [links]
      params = {
          links: links
      }

      DingHook::Message.new.send_msg(params, accounts, :feed_card)
    end
  end
end
