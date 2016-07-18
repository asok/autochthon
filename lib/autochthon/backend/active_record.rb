require 'autochthon/backend/fetching_all'

begin
  require 'i18n/backend/active_record'

  module Autochthon
    module Backend
      class ActiveRecord
        include I18n::Backend::ActiveRecord::Implementation

        include FetchingAll

        def all_for_locale(locale)
          Hash[I18n::Backend::ActiveRecord::Translation
                 .where(locale: locale)
                 .pluck(:key, :value)]
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
