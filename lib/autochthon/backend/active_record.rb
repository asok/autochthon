begin
  require 'i18n/backend/active_record'

  module Autochthon
    module Backend
      class ActiveRecord
        include I18n::Backend::ActiveRecord::Implementation

        def all(locales = nil)
          scope = I18n::Backend::ActiveRecord::Translation
          scope = scope.where(locale: locales) if locales

          scope.all
        end

        class Migration < ::ActiveRecord::Migration
          def change
            create_table :translations do |t|
              t.string :locale
              t.string :key
              t.text   :value
              t.text   :interpolations
              t.boolean :is_proc, default: false

              t.timestamps null: false
            end
          end
        end
      end
    end
  end
rescue LoadError
end
