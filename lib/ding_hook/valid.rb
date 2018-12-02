module DingHook
  module Valid

    VALID_TYPE = [:text, :link, :markdown, :action_card, :feed_card]

    def check_msg_type_valid(type)
      unless VALID_TYPE.include?(type.to_sym)
        raise DingHook::Exception::MsgTypeError, "无效消息类型，目前支持：#{VALID_TYPE.join(', ')}"
      end
    end

    def check_account_valid(accounts)
      accounts.each do |account|
        token = DingHook.config.fetch(account.to_sym, nil)

        if token.nil?
          raise DingHook::Exception::AccountError, "#{account} 对应的access_token未配置"
        end
      end
    end

  end
end