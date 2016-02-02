begin
  require 'i18n/backend/active_record'

  require_relative './active_record/translation'
  Local::Translation = Local::ActiveRecord::Translation
rescue LoadError
  require_relative './sequel/translation'
  Local::Translation = Local::Sequel::Translation
end
