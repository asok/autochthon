require 'erb'
require 'json'
require 'sinatra/base'

require_relative './translation'

module Local
  class Web < Sinatra::Base
    enable :sessions

    set :root, File.expand_path(File.dirname(__FILE__) + "/../..")
    set :views, "#{root}/public"

    def json
      @json ||= JSON.parse(request.body.read, symbolize_names: true)
    end

    def symbolize_keys(h)
      Hash[h.map{ |k, v| [k.intern, v] }]
    end

    get '/' do
      erb :index
    end

    get '/translations' do
      content_type :json

      Translation.order(:id).all.to_json
    end

    get '/query' do
      content_type :json

      Translation.filter(symbolize_keys(params["q"])).all.to_json
    end

    get '/translations/:id' do
      content_type :json

      Translation[params[:id]].to_json
    end

    post '/translations' do
      content_type :json

      Translation.insert(locale: json[:locale],
                          key: json[:key],
                          value: json[:value]).to_json
    end

    put '/translations/:id' do
      content_type :json

      t = Translation[params[:id]]
      t.update(json)
      t.to_json
    end

    delete '/translations/:id' do
      content_type :json

      Translation[params[:id]].delete
    end
  end
end

if defined?(::ActionDispatch::Request::Session) &&
   !::ActionDispatch::Request::Session.respond_to?(:each)
  # mperham/sidekiq#2460
  # Rack apps can't reuse the Rails session store without
  # this monkeypatch
  class ActionDispatch::Request::Session
    def each(&block)
      hash = self.to_hash
      hash.each(&block)
    end
  end
end
