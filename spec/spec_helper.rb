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

  c.before(:each) do |ex|
    Autochthon.backend = if ex.metadata[:type] == :feature
                           Autochthon::Backend::ActiveRecord.new
                         else
                           Autochthon::Backend::Simple.new
                         end

    Autochthon.backend.instance_variable_set(:@translations, nil)
  end

  c.before(:all, active_record: true) do
    ActiveRecord::Base.establish_connection(
      adapter:  "sqlite3",
      database: "local",
      dbfile:   ":memory:"
    )
  end

  c.before(:each, translations_table: true) do
    unless I18n::Backend::ActiveRecord::Translation.table_exists?
      Autochthon::Backend::ActiveRecord::Migration.new.change
    end
  end

  c.after(:each, translations_table: true) do
    I18n::Backend::ActiveRecord::Translation.delete_all
  end
end
