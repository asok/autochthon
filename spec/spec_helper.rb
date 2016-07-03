require 'bundler'
ENV['RACK_ENV'] = 'test'
Bundler.require(:default, 'test')
Bundler.require(:default, 'development')

require 'rack/test'
require 'rspec'

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
    Autochthon.backend = Autochthon::Simple::Backend.new
  end

  c.before(:each) do
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
      Autochthon::ActiveRecord::Migration.new.change
    end
  end
end
