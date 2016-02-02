require 'i18n'

require_relative './active_record/backend'
require_relative './simple/backend'

module Local
  case I18n.backend.class.to_s
  when 'I18n::Backend::ActiveRecord'
    Backend = Local::ActiveRecord::Backend
  else
    Backend = Local::Simple::Backend
  end
end
