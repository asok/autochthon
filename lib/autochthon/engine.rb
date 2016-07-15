module Autochthon
  class Engine < ::Rails::Engine
    isolate_namespace Autochthon

    rake_tasks do
      load 'autochthon/tasks/rails.rake'
    end

    config.to_prepare do
      Rails.application.config.assets.precompile += %w(autochthon.js)
    end
  end
end if defined?(::Rails)
