$:.unshift(File.dirname(__FILE__))

require 'config/environment'
require 'api/v1'
require 'app/ymlator'
require 'config/logging'
require 'rack/contrib'

ENV['RACK_ENV'] ||= 'development'
set :environment, ENV['RACK_ENV'].to_sym

use Rack::CommonLogger

map "/api/ymlator/v1" do
  use Rack::PostBodyContentTypeParser
  use Rack::MethodOverride
  run YmlatorV1
end

map "/" do
  run YmlatorApp
end


map "/app/assets" do
  environment = Sprockets::Environment.new
  stylesheet_path = 'app/assets/css'
  environment.append_path stylesheet_path
  Dir.glob("#{stylesheet_path}/**/*").each do |dir|
    environment.append_path dir if File.directory? dir
  end

  environment.append_path 'app/assets/js'
  environment.append_path 'app/assets/images'

  Sprockets::Helpers.configure do |config|
    config.environment = environment
    config.prefix      = "/app/assets"
    config.digest      = true
  end
  run environment
end