require 'spec_helper'
require 'autochthon/backend/active_record'

RSpec.describe Autochthon::Backend::ActiveRecord,
               with_backend: Autochthon::Backend::ActiveRecord do
  it{ should be_a(I18n::Backend::ActiveRecord::Implementation) }

  describe '#all', translations_table: true do
    include_examples :fetching_all_translations
  end
end
