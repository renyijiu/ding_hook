require 'test_helper'

class DingHook::DingTest < Minitest::Test

  def test_it_should_set_configuration
    params = {
        author: 'renyijiu',
        email: 'me@renyijiu.com'
    }

    config = DingHook::Config.instance
    res = config.configuration do |tmp|
      params.each do |key, value|
        tmp[key] = value
      end
    end

    assert_equal params, res
  end
end