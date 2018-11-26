require 'yaml'
require 'erb'
require 'singleton'

module DingHook
  class Config
    include Singleton

    def configuration
      config = {}.tap { |config| yield(config) }

      yaml_settings.tap do |tmp_config|
        config.each do |key, value|
          tmp_config[key.to_sym] = value if value
        end
      end
    end

    private

    def yaml_settings
      @yaml_settings ||= begin
        if defined?(Rails::VERSION)
          file = Rails.root.join('config', 'dinghook.yml')

          resolve_config_file(file)
        else
          config_file = File.join(Dir.getwd, 'config', 'dinghook.yml')
          home_config_file = File.join(Dir.home, '.dinghook.yml')

          return resolve_config_file(config_file) if File.exist?(config_file)

          resolve_config_file(home_config_file)
        end
      end
    end

    def resolve_config_file(file)
      File.exist?(file) ? YAML.load(ERB.new(File.read(file)).result) : {}
    end

  end
end