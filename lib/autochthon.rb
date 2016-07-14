require "autochthon/version"
require "autochthon/web"
require 'autochthon/engine'
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

    def mount_point=(mount_point)
      @@mount_point = mount_point
    end

    def mount_point
      @@mount_point
    end
  end

  extend Methods
end
