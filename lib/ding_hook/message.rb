require 'uri'
require 'openssl'
require 'json'
require 'net/http'

module DingHook
  class Message

    VALID_TYPE = [:text, :link, :markdown, :action_card, :feed_card]

    def send_msg(hook_url, params, type = :text)
      if VALID_TYPE.include?(type.to_sym)
        body = send("#{type}_body_params".to_sym, params)
      else
        raise DingHook::Exception::MsgTypeError, "无效消息类型，目前支持：#{VALID_TYPE.join(', ')}"
      end

      res = post(hook_url, body)
      JSON.parse(res.body.force_encoding('UTF-8'))
    end

    private

    def post(hook_url, body)
      url = URI(hook_url)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = ::OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request['content-type'] = 'application/json'
      request.body = body

      http.request(request)
    end

    def text_body_params(params)
      {
          msgtype: :text,
          text: {
              content: params.fetch(:text, nil)
          },
          at: {
              atMobiles: params.fetch(:at_mobiles, []),
              isAtAll: params.fetch(:is_at_all, false)
          }
      }.to_json
    end

    def link_body_params(params)
      {
          msgtype: :link,
          link: {
              text: params.fetch(:text, nil),
              title: params.fetch(:title, nil),
              picUrl: params.fetch(:pic_url, nil),
              messageUrl: params.fetch(:message_url, nil)
          }
      }.to_json
    end

    def markdown_body_params(params)
      {
          msgtype: :markdown,
          markdown: {
              title: params.fetch(:title, nil),
              text: params.fetch(:text, nil)
          },
          at: {
              atMobiles: params.fetch(:at_mobiles, []),
              isAtAll: params.fetch(:is_at_all, false)
          }
      }.to_json
    end

    def action_card_body_params(params)
      btns = params.fetch(:btns, nil)

      if btns.nil?
        res = {singleTitle: params.fetch(:single_title, nil), singleURL: params.fetch(:single_url, nil)}
      else
        res = {btns: btns.map{ |btn| {title: btn.fetch(:title, nil), actionURL: btn.fetch(:action_url, nil)} }}
      end

      {
          msgtype: :actionCard,
          actionCard: {
            title: params.fetch(:title, nil),
            text: params.fetch(:text, nil),
            btnOrientation: params.fetch(:btn_orientation, '0'),
            hideAvator: params.fetch(:hide_avator, '0'),
          }.merge(res)
      }.to_json
    end

    def feed_card_body_params(params)
      links = params.fetch(:links, [{}]).map do |link|
        {
            title: link.fetch(:title, nil),
            messageURL: link.fetch(:message_url, nil),
            pic_url: link.fetch(:pic_url, nil)
        }
      end

      {
          msgtype: :feedCard,
          feedCard: {
              links: links
          }
      }.to_json
    end
  end
end