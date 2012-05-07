# encoding: utf-8

require "sinatra/base"
require "sinatra/reloader"
require 'sinatra/content_for'
require 'json'
require 'sprockets/helpers'

class YmlatorApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :haml, :layout => :layout

  configure :development do
    register Sinatra::Reloader
  end
  
  helpers do
    include Sprockets::Helpers
    include Sinatra::ContentFor    
  end
  
  helpers do
    # todo: refactor this uglybuglyness
    def render_key(key, val, root=nil)
      path = root && "#{root}.#{key}" || key
      res = ""
      if val.is_a? Hash
        res << "<fieldset>"
        res << "<legend>&raquo; #{key}</legend>"
        val.each do |k,v|
          res << render_key(k,v, path)
        end
        res << "</fieldset>"        
      else
        val = CGI.escapeHTML(val) if val
        height = val && ((val.length * 0.3)+val.count("\n")*16) || 40
        height = [height, 50].max
        res << <<-eos
                <div class="control-group">
                  <label class="control-label" for="id_#{path}">#{key}</label>
                  <div class="controls">
                    <div class="input-append">
                      <textarea name="#{path}" id="id_#{path}" style="float: left;height: #{height}px">#{val}</textarea>
                    </div>
                  </div>
                </div>
              eos
      end
      res
    end
  end

  before do
    cache_control :private, :no_cache, :no_store, :must_revalidate
  end

  get '/' do
    haml :index
  end

  get '/items/:key/edit' do |key|
    item = Item.find_by_key(key)
    haml :item, :locals => {:item => item}
  end

  get '/items/:key/download' do |key|
    item = Item.find_by_key(key)
    ext = nil
    basename = if item.name
      ext = File.extname(item.name)
      File.basename(item.name, ext)
    end

    basename ||= if item.description
      ext = '.yml'
      item.description[0..20]
    end

    basename ||= if item.key
      ext = '.yml'
      item.key
    end
    content_type :yml
    attachment "#{basename.parameterize("-")}#{ext}"
    YAML::dump(item.value)
  end

end
