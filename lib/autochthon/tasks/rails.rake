require 'autochthon/backend/active_record'

namespace :autochthon do
  desc "Create translations table"
  task create: :environment do
    Autochthon::Backend::ActiveRecord::Migration.new.change
  end

  desc "Reads all translations from yml files and inserts them into db"
  task import: :environment do
    backend = Autochthon::Backend::Simple.new

    locales = (ENV['LOCALES'] || '').split(',')
    locales = backend.available_locales #if locales.empty?

    fn = -> do
      backend.all(locales).each do |t|
        Autochthon.backend.store_translations(t[:locale], {t[:key] => t[:value]})
      end
    end

    if Autochthon.backend.class == Autochthon::Backend::ActiveRecord
      ActiveRecord::Base.transaction(&fn)
    else
      fn.call
    end
  end
end
