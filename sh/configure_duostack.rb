#! /usr/bin/env ruby
require 'rubygems'
require 'rake'
require 'base64'

config = Base64.encode64(File.read('config/config.yml')).gsub("\n","")
sh "duostack env add CONFIG_YML=#{config}"
