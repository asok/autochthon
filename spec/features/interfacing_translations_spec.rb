require 'spec_helper'

RSpec.describe "Browsing translations from the app endpoint",
               type: :feature,
               translations_table: true,
               active_record: true,
               js: true do

  before do
    Autochthon.backend.store_translations(:en, {baz: {b: 'bar'}})

    visit '/'
    expect(page).to have_css('table')
  end

  it 'is possible to browse the translations' do
    expect(page).to have_xpath("//td[text()='en']")
    expect(page).to have_xpath("//td[text()='baz.b']")
    expect(page).to have_xpath("//td[text()='bar']")
  end

  xit 'possible to filter the translations' do
  end

  it 'is possible to update the translations' do
    find("//td[text()='bar']").click
    find("//textarea[text()='bar']").set("foo")
    find("//span[text()='OK']").click
    expect(page).to_not have_css('textarea')
    expect(Autochthon.backend.translate(:en, 'baz.b')).to eq('foo')
  end
end
