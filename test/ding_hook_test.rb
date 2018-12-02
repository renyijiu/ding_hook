require "test_helper"

class DingHookTest < Minitest::Test

  def setup
    Singleton.__init__(DingHook::Config)

    DingHook::Message.any_instance.stubs(:post).returns(OpenStruct.new(body: {errmsg: 'ok', errcode: 0}.to_json))
    DingHook.configure do |config|
      config[:default] = 'helloworld'
      config[:test] = 'hello'
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::DingHook::VERSION
  end

  def test_it_should_set_config
    Singleton.__init__(DingHook::Config)

    params = {
        author: 'renyijiu',
        email: 'me@renyijiu.com'
    }

    res = DingHook.configure do |tmp|
      params.each do |key, value|
        tmp[key] = value
      end
    end

    assert_equal params, res
    assert_equal DingHook.config, res
  end

  def test_it_should_send_msg
    params = {
        text: 'hello'
    }

    flag, _ = DingHook.send_msg(params, :text, [:default, :test])
    assert flag
  end

  def test_it_should_send_text_msg
    flag, _ = DingHook.send_text_msg('hello', {}, [:default, :test])

    assert flag
  end

  def test_it_should_send_link_msg
    flag, _ = DingHook.send_link_msg('hello', 'world', 'https://renyijiu.com', {}, [:default, :test])

    assert flag
  end

  def test_should_send_merkdown_msg
    flag, _ = DingHook.send_markdown_msg('hello', "## hello",{}, [:default, :test])

    assert flag
  end

  def test_should_send_single_action_card
    flag, _ = DingHook.send_single_action_card('hello', "## hello", 'world', 'https://renyijiu.com', {}, [:default, :test])

    assert flag
  end

  def test_should_send_btns_action_card
    btns = [
        {
            title: 'hello',
            action_url: 'https://renyijiu.com'
        },
        {
            title: 'world',
            action_url: 'https://renyijiu.com'
        }
    ]

    flag, _ = DingHook.send_btns_action_card('hello', "hello", btns, {}, [:default, :test])

    assert flag
  end

  def test_should_send_feed_card
    links = [
        {
            title: 'hello',
            message_url: 'https://renyijiu.com',
            pic_url: 'https://renyijiu.com'
        },
        {
            title: 'world',
            message_url: 'https://renyijiu.com',
            pic_url: 'https://renyijiu.com'
        }
    ]

    flag, _ = DingHook.send_feed_card(links, [:default, :test])

    assert flag
  end
end
