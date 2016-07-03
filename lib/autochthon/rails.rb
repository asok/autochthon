module Autochthon
  class Rails < ::Rails::Engine
    rake_tasks do
      load 'autochthon/tasks/rails.rake'
    end
  end
end if defined?(::Rails)
