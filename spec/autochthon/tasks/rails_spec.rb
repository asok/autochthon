require 'spec_helper'
require 'active_record'
load 'autochthon/tasks/rails.rake'

RSpec.describe 'The tasks for rails', active_record: true do
  before(:all) do
    Rake::Task.define_task(:environment) {}
  end

  describe ':create' do
    before do
      Class.new(ActiveRecord::Migration) do
        self.verbose = false

        def up
          drop_table :translations
        end
      end.new.up
    end

    it 'creates translations table' do
      Rake::Task['autochthon:create'].invoke
      expect(ActiveRecord::Base.connection.table_exists?(:translations)).to be(true)
    end
  end

  describe ':import', translations_table: true do
    let!(:simple) { Autochthon::Backend::Simple.new }
    let!(:ar)     { Autochthon::Backend::ActiveRecord.new }

    before do
      allow(Autochthon::Backend::Simple).to receive(:new) { simple }
      simple.store_translations(:en, {foo: {a:  'bar'}})
      simple.store_translations(:en, {baz: {b: 'bar'}})
      simple.store_translations(:pl, {foo: 'bar'})

      Rake::Task['autochthon:import'].invoke
    end

    it 'imports translations from the Simple backend to ActiveRecord backend' do
      expect(ar.translate(:en, 'foo.a')).to eq('bar')
      expect(ar.translate(:en, 'baz.b')).to eq('bar')
      expect(ar.translate(:pl, 'foo')).to eq('bar')
    end
  end
end
