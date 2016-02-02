require "local/version"
require "local/web"
require 'local/rails'
require 'local/simple/backend'
require 'local/active_record/backend'

module Local
  module Methods
    def backend=(backend)
      @@backend = backend
    end

    def backend
      @@backend
    end
  end

  extend Methods
end
