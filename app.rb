# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'fluent-logger'
require 'haml'
require 'json'
require 'date'
require 'time'

class FluentdJsonReciever < Sinatra::Base
  #require './helpers/render_partial'

  def initialize(app = nil, params = {})
    super(app)
    @fluentd = Fluent::Logger::FluentLogger.open(nil,
      host = 'localhost',
      port = '19999')
  end

  # Logging
  configure :development, :production do
    enable :logging
  end

  # Reloader
  configure :development do
    register Sinatra::Reloader
  end

  # Root Index
  get '/' do
    haml :index
  end

  # Generic Routing
  post '/?' do
    jdata = prams[:data]
    for_json = JSON.parse(jdata)
    @fluentd.post(jdata, for_json)
  end

  run! if app_file == $0
end
