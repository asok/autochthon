require 'spec_helper'
require 'active_record'
load 'autochthon/tasks/rails.rake'

RSpec.describe 'The tasks for rails' do
  before(:all) do
    Rake::Task.define_task(:environment) {}
  end

  describe ':create',
           with_backend: Autochthon::Backend::ActiveRecord do
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

  describe '::import' do
    let!(:simple) { Autochthon::Backend::Simple.new }

    before do
      allow(Autochthon::Backend::Simple).to receive(:new) { simple }
      simple.store_translations(:en, {foo: {a: 'bar'}})
      simple.store_translations(:en, {baz: {b: 'bar'}})
      simple.store_translations(:pl, {foo: 'bar'})
    end
    after { Rake::Task['autochthon:import'].reenable }

    [
      Autochthon::Backend::ActiveRecord,
      Autochthon::Backend::Redis
    ].each do |backend|

      context("backend is #{backend.to_s}", with_backend: backend) do
        it 'imports translations from the Simple backend' do
          Rake::Task['autochthon:import'].invoke

          expect(Autochthon.backend.translate(:en, 'foo.a')).to eq('bar')
          expect(Autochthon.backend.translate(:en, 'baz.b')).to eq('bar')
          expect(Autochthon.backend.translate(:pl, 'foo')).to eq('bar')
        end
      end
    end
  end
end
