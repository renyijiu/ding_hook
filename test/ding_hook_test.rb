require "test_helper"

class DingHookTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DingHook::VERSION
  end

  def test_is_should_set_config
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

end
