require 'spec_helper'

RSpec.describe Local::Simple::Backend do
  it{ should be_a(I18n::Backend::Simple::Implementation) }

  describe '#all' do
    before do
      subject.store_translations(:en, {foo: {a:  'bar'}})
      subject.store_translations(:en, {baz: {b: 'bar'}})
      subject.store_translations(:pl, {foo: 'bar'})
    end

    it 'returns all translations' do
      all = subject.all
      expect(all).to include(key: :"foo.a", value: "bar", locale: :en)
      expect(all).to include(key: :"baz.b", value: "bar", locale: :en)
      expect(all).to include(key: :foo,     value: "bar", locale: :pl)
    end
  end
end
