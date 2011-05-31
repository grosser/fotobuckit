require 'active_support/core_ext/hash/indifferent_access'

env = defined?(Rails.env) ? Rails.env : (ENV['RAILS_ENV'] || 'development')
dotcloud_config = '/home/dotcloud/vars.json' # must be generated manually ... temp fix
normal_config = 'config/config.yml'

config = if encoded = ENV['CONFIG_YML']
  require 'base64'
  YAML.load Base64.decode64(encoded)
elsif File.exist? dotcloud_config
  require 'json'
  JSON.load File.read dotcloud_config
else
  YAML.load File.read normal_config
end

CFG = config[env].with_indifferent_access.freeze
