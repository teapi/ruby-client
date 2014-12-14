require 'spec_helper'

describe 'documents' do
  include HttpHelper

  it "inserts a single document" do
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents?ts=1424959555')
      assert_auth(args, 'over9000', '29fa1c33729ef7c64e4e430a5c90c772f8a52c1545c099b773a1e6a589713f64')
      assert_body(args, {type: 'people', doc: {name: 'leto'}})
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Documents.create('people', {name: 'leto'}).code).to eq(201)
  end
end
