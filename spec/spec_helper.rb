require 'bundler'
ENV['RACK_ENV'] = 'test'
Bundler.require(:default, 'test')
Bundler.require(:default, 'development')

require 'rack/test'
require 'rspec'

require "capybara/rspec"
require 'capybara/webkit'

Sinatra::Application.environment = :test

Capybara.app               = Autochthon::Web
Capybara.javascript_driver = :webkit
Capybara.default_selector  = :xpath

require "autochthon"

module RSpecMixin
  include Rack::Test::Methods

  def app
    Autochthon::Web
  end

  def get_json(path, data = {})
    get path, data, "Content-Type" => "application/json"
  end

  def post_json(path, data)
    post path, data.to_json, "Content-Type" => "application/json"
  end

  def put_json(path, data)
    put path, data.to_json, "Content-Type" => "application/json"
  end

  def delete_json(path)
    delete path, {}, "Content-Type" => "application/json"
  end
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.before(:suite) do
    Autochthon.backend = I18n.backend
  end

  c.before(:each) do
    Autochthon.backend.instance_variable_set(:@translations, nil)
  end

  c.before(:each, with_backend: Autochthon::Backend::ActiveRecord) do
    Autochthon.backend = Autochthon::Backend::ActiveRecord.new

    unless I18n::Backend::ActiveRecord::Translation.table_exists?
      Autochthon::Backend::ActiveRecord::Migration.new.change
    end
  end

  c.before(:all, with_backend: Autochthon::Backend::ActiveRecord) do
    ActiveRecord::Base.establish_connection(
      adapter:  "sqlite3",
      database: "local",
      dbfile:   ":memory:"
    )
  end

  c.after(:each, with_backend: Autochthon::Backend::ActiveRecord) do
    I18n::Backend::ActiveRecord::Translation.delete_all
  end

  c.before(:each, with_backend: Autochthon::Backend::Redis) do
    Autochthon.backend = Autochthon::Backend::Redis.new(db: ENV['TEST_REDIS_DB'] || 15)
  end

  c.after(:each, with_backend: Autochthon::Backend::Redis) do
    Autochthon.backend.store.flushdb
  end

  c.before(:each, with_backend: Autochthon::Backend::Simple) do
    Autochthon.backend = Autochthon::Backend::Simple.new
  end
end

RSpec.shared_examples_for :fetching_all_translations do
  describe "#all" do
    subject { Autochthon.backend }

    before do
      subject.store_translations(:en, {foo: {a:  'bar'}})
      subject.store_translations(:en, {baz: {b: 'bar'}})
      subject.store_translations(:pl, {foo: 'bar'})
    end

    it 'returns all translations' do
      expect(subject.all).to include(key: :"foo.a", value: "bar", locale: :en)
      expect(subject.all).to include(key: :"baz.b", value: "bar", locale: :en)
      expect(subject.all).to include(key: :foo,     value: "bar", locale: :pl)
    end

    context 'passing in locales' do
      it 'returns translations for the passed locales only' do
        expect(subject.all([:pl])).to eq([key: :foo, value: "bar", locale: :pl])
      end
    end
  end
end
