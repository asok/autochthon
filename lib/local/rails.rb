module Local
  class Rails < ::Rails::Engine
    rake_tasks do
      load 'local/tasks/rails.rake'
    end
  end
end if defined?(::Rails)
