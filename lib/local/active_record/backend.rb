begin
  require 'i18n/backend/active_record'

  module Local
    module ActiveRecord
      class Backend
        include I18n::Backend::ActiveRecord::Implementation

        def all
          I18n::Backend::ActiveRecord::Translation.all
        end
      end
    end
  end
rescue LoadError
end
