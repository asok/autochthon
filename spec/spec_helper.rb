require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative "../lib/local"

require 'database_cleaner'

module RSpecMixin
  include Rack::Test::Methods

  def app
    Local::Web
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

  def translations
    Local::Translation
  end
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.before(:suite) do
    DatabaseCleaner[:sequel].strategy = :transaction
    DatabaseCleaner[:sequel].clean_with(:truncation)
  end

  c.around(:each) do |example|
    DatabaseCleaner[:sequel].cleaning do
      example.run
    end
  end
end
