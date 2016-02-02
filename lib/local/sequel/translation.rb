require 'sequel'
require 'yaml'

require_relative './db'

Sequel.extension :core_extensions
Sequel::Model.plugin :json_serializer

Local::Sequel::DB.create_table

module Local
  module Sequel
    class Translation < ::Sequel::Model
      plugin :serialization, :yaml, :value
    end
  end
end
