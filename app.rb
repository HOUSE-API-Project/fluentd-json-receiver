# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'fluent-logger'
require 'haml'
require 'json'
require 'date'
require 'time'

class FluentdJsonReceiver < Sinatra::Base
  #require './helpers/render_partial'

  def initialize(app = nil, params = {})
    super(app)
    @fluentd = Fluent::Logger::FluentLogger.open(nil,
      host = 'localhost',
      port = '29999')
    @root = Sinatra::Application.environment == :production ? '/post/' : '/'
  end

  def logger
    env['app.logger'] || env['rack.logger']
  end

  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and
      @auth.credentials == ['username', 'password']
    end
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
    protected!
    haml :index
  end

  # Generic Routing
  post '/?' do
    protected!
    json = params[:data].class == Hash ? params[:data] : JSON.parse(params[:data])
    tag  = params[:tag]
    @fluentd.post(tag, json)
  end

  run! if app_file == $0
end
