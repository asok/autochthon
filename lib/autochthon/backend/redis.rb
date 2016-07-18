begin
  require 'i18n/backend/redis'

  module Autochthon
    module Backend
      class Redis < I18n::Backend::Redis
        include FetchingAll

        def all_for_locale(locale)
          store.keys("#{locale}.*").inject({}) do |translations, key|
            main_key = key[(locale.size+1)..-1]
            translations.merge(main_key => translate(locale, main_key))
          end
        end
      end
    end
  end
rescue LoadError
end
