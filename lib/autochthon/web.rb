require 'erb'
require 'json'
require 'sinatra/base'

module Autochthon
  class Web < Sinatra::Base
    enable :sessions

    set :root, File.expand_path(File.dirname(__FILE__) + "/../..")
    set :views, "#{root}/public"

    def json
      @json ||= JSON.parse(request.body.read, symbolize_names: true)
    end

    def unflatten_data(key, value)
      keys = key.split(I18n::Backend::Flatten::FLATTEN_SEPARATOR)

      keys[0...-1].reverse.inject(keys.last => value) do |out, k|
        {k => out}
      end
    end

    get '/' do
      erb :index
    end

    get '/translations' do
      content_type :json

      Autochthon.backend.all.to_json
    end

    post '/translations' do
      content_type :json

      Autochthon.backend.store_translations(json[:locale],
                                            unflatten_data(json[:key], json[:value]),
                                            escape: false).to_json
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
