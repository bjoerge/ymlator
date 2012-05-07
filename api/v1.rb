# encoding: utf-8
require "json"
require 'sinatra/contrib'
require 'sinatra/petroglyph'

Dir.glob("#{File.dirname(__FILE__)}/v1/**/*.rb").each{ |file| require file }

class YmlatorV1 < Sinatra::Base
  set :root, "#{File.dirname(__FILE__)}/v1"

  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type :json
  end

  post '/items' do
    item = Item.new
    item.name = params[:item][:name] if params[:item][:name]
    item.description = params[:item][:description] if params[:item][:description]
    item.value = params[:item][:value]
    item.value = YAML::load(item.value) unless item.value.is_a? Hash
    item.save
    response.status = 201
    pg :item, :locals => {:item => item}
  end

  put '/items/:key' do |key|
    item = Item.find_by_key(key)
    request_value = params[:item][:value]
    item.value.deep_merge! request_value
    item.save
    pg :item, :locals => {:item => item}
  end

  private
  def set_val_by_path(hash, pathstr, val)
    parts = pathstr.split(".")
    parts.each_index do |part, i|
      last = i == parts.length - 1
      hash = hash[part] ||= (last ? val : {})
    end
  end
end
