require 'spec_helper'
require 'local/active_record/backend'
require 'local/active_record/migration'

RSpec.describe Local::ActiveRecord::Backend do
  it{ should be_a(I18n::Backend::ActiveRecord::Implementation) }

  describe '#all' do
    before(:all) do
      ActiveRecord::Base.establish_connection(
        adapter:  "sqlite3",
        database: "local",
        dbfile:   ":memory:"
      )

      unless I18n::Backend::ActiveRecord::Translation.table_exists?
        Local::ActiveRecord::Migration.new.change
      end
    end

    around do |example| 
      Local.backend = Local::ActiveRecord::Backend.new
      ActiveRecord::Base.transaction { example.run }
      Local.backend = Local::Simple::Backend.new
    end

    before do
      subject.store_translations(:en, {foo: {a:  'bar'}})
      subject.store_translations(:en, {baz: {b: 'bar'}})
      subject.store_translations(:pl, {foo: 'bar'})
    end

    def normalize(translations)
      @normalize ||= JSON.parse(translations.to_json).map do |t|
        t.keep_if{ |k, _| %w[locale key value].include? k }
      end
    end

    it 'returns all translations' do
      expect(normalize(subject.all)).
        to include('key' => "foo.a", 'value' => "bar", 'locale' => 'en')
      expect(normalize(subject.all)).
        to include('key' => "baz.b", 'value' => "bar", 'locale' => 'en')
      expect(normalize(subject.all)).
        to include('key' => "foo",   'value' => "bar", 'locale' => 'pl')
    end

    context 'passing in locales' do
      it 'returns translations for the passed locales only' do
        expect(normalize(subject.all(['pl']))).
          to eq(['key' => "foo",   'value' => "bar", 'locale' => 'pl'])
      end
    end
  end
end
