require 'spec_helper'

RSpec.describe Local::Web do
  describe "/" do
    it "serves the html file" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('text/html;charset=utf-8')
    end
  end

  describe "GET /translations" do
    let!(:translation) do
      id = translations.insert(key: 'key', value: 'value')
      translations[id]
    end

    it 'serves all translations' do
      get_json "/translations"
      expect(last_response.body).to match([translation].to_json)
    end
  end

  describe "GET /query" do
    let!(:translation1) do
      id = translations.insert(key: 'key', value: 'value')
      translations[id]
    end
    let!(:translation2) do
      id = translations.insert(key: 'key', value: 'bar')
      translations[id]
    end

    it 'serves all translations' do
      get_json "/query", {q: {value: 'bar'}}
      expect(last_response.body).to match([translation2].to_json)
    end
  end

  describe "POST /translations" do
    it 'serves all translations' do
      post_json "/translations", {locale: 'en', key: 'foo', value: 'bar'}

      t = translations.last
      expect(t.locale).to eq('en')
      expect(t.key).to eq('foo')
      expect(t.value).to eq('bar')
    end
  end

  describe "PUT /translations/:id" do
    let!(:translation) do
      id = translations.insert(key: 'key', value: 'value')
      translations[id]
    end

    it 'updates translation' do
      put_json "/translations/#{translation.id}", value: 'a new value'
      expect(translations[translation.id].value).to eq('a new value')
    end
  end

  describe "DELETE /translations/:id" do
    let!(:translation) do
      id = translations.insert(key: 'key', value: 'value')
      translations[id]
    end

    it 'deletes translation' do
      delete_json "/translations/#{translation.id}"
      expect(translations[translation.id]).to be_nil
    end
  end
end
