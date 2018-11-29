require 'test_helper'

class DingHook::DingTest < Minitest::Test

  def setup
    Singleton.__init__(DingHook::Config)

    DingHook::Message.any_instance.stubs(:post).returns(OpenStruct.new(body: {errmsg: 'ok', errcode: 0}.to_json))
    DingHook.configure do |config|
      config[:default] = 'helloworld'
    end

    @ding = DingHook::Message.new
  end

  def test_it_send_invalid_message_type
    params = {}

    assert_raises DingHook::Exception::MsgTypeError do
      @ding.send_msg(params, :hello, :test)
    end
  end

  def test_it_send_invalid_account
    params = {}

    assert_raises DingHook::Exception::AccountError do
      @ding.send_msg(params, :test, :text)
    end
  end


  def test_it_should_send_text_message
    params = {
        text: 'renyijiu'
    }

    flag, _ = @ding.send_msg(params,:default, :text)
    assert flag
  end

  def test_it_should_send_link_message
    params = {
        text: 'renyijiu',
        title: 'hello world',
        pic_url: 'https://renyijiu.com',
        message_url: 'https://renyijiu.com'
    }

    flag, _ = @ding.send_msg(params, :default, :link)
    assert flag
  end

  def test_it_should_send_markdown_message
    params = {
        text: 'renyijiu',
        title: 'hello world',
        at_mobiles: ['12345678901'],
        is_at_all: true
    }

    flag, _ = @ding.send_msg(params, :default, :markdown)
    assert flag
  end

  def test_it_should_send_action_card_single
    params = {
        single_title: 'renyijiu',
        single_url: 'https://rnyijiu.com',
        title: 'renyijiu',
        text: 'renyijiu',
        btn_orientation: 1,
        hide_avator: 1
    }

    flag, _ = @ding.send_msg(params, :default, :action_card)
    assert flag
  end

  def test_it_should_send_action_card_btns
    params = {
        title: 'renyijiu',
        text: 'renyijiu',
        btn_orientation: 1,
        hide_avator: 1,
        btns: [
            {
                title: 'hello',
                action_url: 'https://renyijiu.com'
            }
        ]
    }

    flag, _ = @ding.send_msg(params, :default, :action_card)
    assert flag
  end

  def test_it_should_send_feed_card
    params = {
        links: [
            {
                title: 'helloworld',
                message_url: 'https://renyijiu.com',
                pic_url: 'https://renyijiu.com'
            }
        ]
    }

    flag, _ = @ding.send_msg(params, :default, :feed_card)
    assert flag
  end

end