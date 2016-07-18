require 'spec_helper'

RSpec.describe Autochthon::Backend::Redis,
               with_backend: Autochthon::Backend::Redis do
  it{ should be_a(I18n::Backend::Redis) }

  include_examples :fetching_all_translations
end
