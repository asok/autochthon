require "autochthon/version"
require "autochthon/web"
require 'autochthon/engine'
require 'autochthon/backend/simple'
require 'autochthon/backend/active_record'
require 'autochthon/backend/redis'

module Autochthon
  module Methods
    def backend=(backend)
      @@backend = backend
    end

    def backend
      @@backend
    end

    def mount_point=(mount_point)
      @@mount_point = mount_point
    end

    def mount_point
      @@mount_point
    end
  end

  extend Methods
end
