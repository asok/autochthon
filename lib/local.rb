require "local/version"
require "local/web"
require 'local/rails'

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
