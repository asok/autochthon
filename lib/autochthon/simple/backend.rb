module Autochthon
  module Simple
    class Backend
      include I18n::Backend::Flatten
      include I18n::Backend::Simple::Implementation

      def all(locales = available_locales)
        locales.inject([]) do |out, locale| 
          flatten_translations(locale, translate(locale, "."), false, false).each do |key, value| 
            out << {key: key, value: value, locale: locale}
          end
          out
        end
      end
    end
  end
end
