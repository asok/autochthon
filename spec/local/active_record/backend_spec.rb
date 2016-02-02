require 'spec_helper'
require 'local/active_record/backend'

RSpec.describe Local::ActiveRecord::Backend do

  around do |example| 
    Local.backend = Local::ActiveRecord::Backend.new
    example.run
    Local.backend = Local::Simple::Backend.new
  end
  it{ should be_a(I18n::Backend::ActiveRecord::Implementation) }

  # describe '#all' do
  #   before do
  #     subject.store_translations(:en, {foo: {a:  'bar'}})
  #     subject.store_translations(:en, {baz: {b: 'bar'}})
  #     subject.store_translations(:pl, {foo: 'bar'})
  #   end

  #   it 'returns all translations' do
  #     expect(subject.all).to eq([{key: :"foo.a", value: "bar", locale: :en},
  #                                {key: :"baz.b", value: "bar", locale: :en},
  #                                {key: :foo,     value: "bar", locale: :pl}])
  #   end
  # end
end
