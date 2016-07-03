begin
  require 'i18n/backend/active_record'

  module Autochthon
    module ActiveRecord
      class Backend
        include I18n::Backend::ActiveRecord::Implementation

        def all(locales = nil)
          scope = I18n::Backend::ActiveRecord::Translation
          scope = scope.where(locale: locales) if locales

          scope.all
        end
      end
    end
  end
rescue LoadError
end
