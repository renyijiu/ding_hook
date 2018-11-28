require 'test_helper'

class DingHook::DingTest < Minitest::Test

  def setup
    DingHook::Message.any_instance.stubs(:post).returns(OpenStruct.new(body: {errmsg: 'ok', errcode: 0}.to_json))

    @url = 'https://oapi.dingtalk.com/robot/send'
    @ding = DingHook::Message.new
  end

  def test_is_send_invalid_message_type
    params = {}

    assert_raises DingHook::Exception::MsgTypeError do
      @ding.send_msg(@url, params, :test)
    end
  end

  def test_it_should_send_text_message
    params = {
        text: 'renyijiu'
    }

    res = @ding.send_msg(@ur, params, :text)
    assert_equal 0, res['errcode']
  end

  def test_it_should_send_link_message
    params = {
        text: 'renyijiu',
        title: 'hello world',
        pic_url: 'https://renyijiu.com',
        message_url: 'https://renyijiu.com'
    }

    res = @ding.send_msg(@ur, params, :link)
    assert_equal 0, res['errcode']
  end

  def test_it_should_send_markdown_message
    params = {
        text: 'renyijiu',
        title: 'hello world',
        at_mobiles: ['12345678901'],
        is_at_all: true
    }

    res = @ding.send_msg(@url, params, :markdown)
    assert_equal 0, res['errcode']
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

    res = @ding.send_msg(@url, params, :action_card)
    assert_equal 0, res['errcode']
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

    res = @ding.send_msg(@url, params, :action_card)
    assert_equal 0, res['errcode']
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

    res = @ding.send_msg(@url, params, :feed_card)
    assert_equal 0, res['errcode']
  end

end