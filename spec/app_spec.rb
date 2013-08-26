require File.dirname(__FILE__) + '/spec_helper'

require 'fluent-logger'
require 'net/http'
require 'uri'
require 'json'
require 'rest-client'

describe "App" do
  include Rack::Test::Methods

  def app
    @app ||= FluentdJsonReceiver
  end

  it "should post succeed and return the ok" do
    @username = "username"
    @password = "password"
    json = {"hoge" => "fuga"}
    tag = "debug.forward"
    response = RestClient.post("http://#{@username}:#{@password}@133.242.144.202/post",
      {:tag => tag, :data => json},
      {:content_type => :json, :accept => :json})
    response.should be_empty
  end

end
