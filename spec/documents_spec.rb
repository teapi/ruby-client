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

  it "updates a single document" do
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents?ts=1424959555')
      assert_auth(args, 'over9000!', '1bdd9cba08569235035b210df5131b1eb55993fe15fb2b5a2ff94dc39801d332')
      assert_body(args, {type: 'atreides', doc: {name: 'jessica'}})
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000!', sync_secret: 'dune', host: 'fake.teapi.io')
    expect(Teapi::Documents.update('atreides', {name: 'jessica'}).code).to eq(201)
  end

  it "deletes a single document" do
    expect(HTTParty).to receive(:delete) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents?ts=1424959555')
      assert_auth(args, 'over9000!', 'f5cf7c3c2fe6084a24151a5d3973d0f1837530098603f826da9aaa578985ec75')
      assert_body(args, {type: 'atreides', id: 545})
      FakeResponse.new('', 204)
    end
    configuration = setup_configuration(sync_key: 'over9000!', sync_secret: 'dune', host: 'fake.teapi.io')
    expect(Teapi::Documents.delete('atreides', 545).code).to eq(204)
  end
end
