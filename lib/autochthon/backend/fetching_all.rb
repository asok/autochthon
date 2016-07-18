module Autochthon
  module Backend
    module FetchingAll
      include I18n::Backend::Flatten

      def all(locales = available_locales)
        locales.inject([]) do |out, locale|
          flatten_keys(all_for_locale(locale), false) do |key, value|
            out << {key: key, value: value, locale: locale}
          end
          out
        end
      end

      def all_for_locale(locale)
        raise NotImplementedError
      end
    end
  end
end
