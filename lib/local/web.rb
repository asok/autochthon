require 'erb'
require 'json'
require 'sinatra/base'

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

    # This way we can defer requiring the db (needed for rails)
    def translations
      require_relative './db'
      Translation
    end

    get '/' do
      erb :index
    end

    get '/translations' do
      content_type :json

      translations.order(:id).all.to_json
    end

    get '/query' do
      content_type :json

      translations.filter(symbolize_keys(params["q"])).all.to_json
    end

    get '/translations/:id' do
      content_type :json

      translations[id: params[:id]].to_json
    end

    post '/translations' do
      content_type :json

      translations.insert(locale: json[:locale],
                          key: json[:key],
                          value: json[:value]).to_json
    end

    put '/translations/:id' do
      content_type :json

      t = translations[params[:id]]
      t.update(json)
      t.to_json
    end

    delete '/translations/:id' do
      content_type :json

      translations[params[:id]].delete
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
