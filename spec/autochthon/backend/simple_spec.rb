require 'spec_helper'

RSpec.describe Autochthon::Backend::Simple,
               with_backend: Autochthon::Backend::Simple do
  it{ should be_a(I18n::Backend::Simple::Implementation) }

  describe '#all' do
    include_examples :fetching_all_translations
  end
end
