module Autochthon
  module TranslationHelper
    def translate!(key, options = {})
      if options[:default]
        raise ArgumentError,
              "You are calling #translate! with an :default option, that does not make sense"
      end

      default = content_tag('span',
                            key.split('.').last.to_s.titleize,
                            'class' => 'translation_missing',
                            'data-local-key' => scope_key_by_partial(key))

      translate(key, options.merge(default: default))
    end

    alias t! translate!
  end
end
