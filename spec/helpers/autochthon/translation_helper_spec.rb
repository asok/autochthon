require 'spec_helper'
require 'action_view'

require_relative '../../../app/helpers/autochthon/translation_helper'

RSpec.describe Autochthon::TranslationHelper do
  subject do
    Class.new do
      include ActionView::Helpers::TranslationHelper
      include Autochthon::TranslationHelper
    end.new
  end

  before { I18n.backend = Autochthon.backend }

  describe 'translate!' do
    it 'generates a span translation' do
      Autochthon.backend.store_translations(I18n.locale, {'a' => 'value'})
      expect(subject.translate!('a')).to eq('value')
    end

    context 'translation is missing' do
      it 'generates a translation_missing span' do
        expect(subject.translate!('c.d')).
          to eq(%Q{<span class="translation_missing" data-local-key="c.d">D</span>})
      end
    end
  end

  describe 't!' do
    it{ expect(subject.method(:t!)).to eq(subject.method(:translate!)) }
  end
end
