require 'spec_helper'

RSpec.describe Autochthon::Web do
  describe "/" do
    it "serves the html file" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('text/html;charset=utf-8')
    end
  end

  describe "GET /translations" do
    let!(:translation) do
      Autochthon.backend.store_translations(:en, 'key' => 'value')
    end

    it 'serves all translations' do
      get_json "/translations"
      expect(JSON.parse(last_response.body)).
        to include('key' => 'key', 'value' => 'value', 'locale' => 'en')
    end
  end

  describe "POST /translations" do
    it 'stores the 1 level translation' do
      post_json "/translations", {locale: 'en', key: 'foo', value: 'bar'}

      expect(Autochthon.backend.translate(:en, 'foo')).to eq('bar')
    end

    it 'stores the multiple level translation' do
      post_json "/translations", {locale: 'en', key: 'foo.baz', value: 'bar'}

      expect(Autochthon.backend.translate(:en, 'foo.baz')).to eq('bar')
    end
  end
end
