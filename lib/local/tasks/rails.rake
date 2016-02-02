namespace :local do
  desc "Create translations table"
  task create: :environment do
    Class.new(ActiveRecord::Migration) do
      def up
        create_table :translations do |t|
          t.string :locale
          t.string :key
          t.text   :value
          t.text   :interpolations
          t.boolean :is_proc, default: false

          t.timestamps null: false
        end
      end
    end.new.up
  end

  desc "Reads all translations from yml files and inserts them into db"
  task import: :environment do
    unless defined?(I18n::Backend::ActiveRecord)
      raise "Please include i18n-active_record gem in your Gemfile"
    end

    backend = Local::Simple::Backend.new

    locales = (ENV['LOCALES'] || '').split(',')
    locales = backend.available_locales if locales.empty?

    ActiveRecord::Base.transaction do
      backend.all(locales).each do |t|
          I18n::Backend::ActiveRecord::Translation.create!(locale: t[:locale],
                                                           key: t[:key],
                                                           value: t[:value])
      end
    end
  end
end
