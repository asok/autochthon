require 'spec_helper'

RSpec.describe "Browsing translations from the app endpoint",
               type: :feature,
               translations_table: true,
               active_record: true,
               js: true do

  before do
    Autochthon.backend.store_translations(:en, {baz: {b: 'bar'}})
  end

  it 'is possible to browse the translations' do
    visit '/'
    expect(page).to have_css('table')

    expect(page).to have_xpath("//td[text()='en']")
    expect(page).to have_xpath("//td[text()='baz.b']")
    expect(page).to have_xpath("//td[text()='bar']")
  end

  it 'is possible to update the missing translation' do
    visit '/'
    expect(page).to have_css('table')

    find("//td[text()='bar']").click
    find("//textarea[text()='bar']").set("foo")
    find("//span[text()='OK']").click
    expect(page).to_not have_css('textarea')
    expect(Autochthon.backend.translate(:en, 'baz.b')).to eq('foo')
  end
end
