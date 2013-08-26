# Fluentd JSON Receiver

## Receive JSON and send to Fluentd

The simple web API interface for Fluentd.

## REST Tutorial

    require 'rest-client'
    json = {"hoge" => "fuga"}
    tag = "debug.forward"
    response = RestClient.post('http://username:password@hostname/url',
      {:tag => tag, :data => json},
    {:content_type => :json, :accept => :json})

## How do I get started?

    bundle install --path=vendor/bundler

## How do I start the application?

Start the app by running:

    bundle exec rake s

