require 'active_support/core_ext/hash/indifferent_access'

env = defined?(Rails.env) ? Rails.env : (ENV['RAILS_ENV'] || 'development')
config = if encoded = ENV['CONFIG_YML']
  require 'base64'
  Base64.decode64(encoded)
else
  File.read('config/config.yml')
end
CFG = YAML.load(config)[env].with_indifferent_access.freeze
