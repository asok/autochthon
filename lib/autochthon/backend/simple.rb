require 'autochthon/backend/fetching_all'

module Autochthon
  module Backend
    class Simple
      include I18n::Backend::Simple::Implementation

      include FetchingAll

      def all_for_locale(locale)
        translate(locale, ".")
      end
    end
  end
end
