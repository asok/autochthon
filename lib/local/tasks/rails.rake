namespace :local do
  desc "Create translations table"
  task create: :environment do
    require 'local/sequel/db'
    Local::Sequel::DB.create_table
  end

  desc "Reads all translations from yml files and inserts them into db"
  task import: :environment do
    unless defined?(I18n::Backend::ActiveRecord)
      raise "Please include i18n-active_record gem in your Gemfile"
    end

    backend = I18n::Backend::Simple.new

    flatter = Class.new{ include I18n::Backend::Flatten }.new

    locales = (ENV['LOCALES'] || '').split(',')
    locales = backend.available_locales if locales.empty?

    translations = locales.inject({}) do |out, locale| 
      out.merge(locale => flatter.flatten_translations(locale, backend.translate(locale, "."), false, false))
    end

    ActiveRecord::Base.transaction do
      translations.each do |locale, hash|
        hash.each do |key, value|
          I18n::Backend::ActiveRecord::Translation.create!(locale: locale,
                                                           key: key,
                                                           value: value)
        end
      end
    end
  end
end
