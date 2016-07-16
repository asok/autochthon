module Autochthon
  class Engine < ::Rails::Engine
    isolate_namespace Autochthon

    rake_tasks do
      load 'autochthon/tasks/rails.rake'
    end
  end
end if defined?(::Rails)
