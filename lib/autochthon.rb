require "autochthon/version"
require "autochthon/web"
require 'autochthon/rails'
require 'autochthon/simple/backend'
require 'autochthon/active_record/backend'

module Autochthon
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
