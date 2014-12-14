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
    expect(HTTParty).to receive(:put) do |url, args|
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

  it "gzips larger documents" do
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents?ts=1424959555')
      assert_auth(args, 'over9000', '9a1b74cc93916d6e63d57b1219b38b31c8fee6672355e46cbdbb428c6aee230a')
      assert_body(args, {type: 'people', doc: {name: 'a' * 1024}}, true)
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Documents.create('people', {name: 'a' * 1024}).code).to eq(201)
  end

  it "handles bulk requests" do
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents?ts=1424959555')
      assert_auth(args, 'over9000', '53995f97faf21ab5627e9429ed46aa1b05cbcf79445bc9f5131f60fb6ebe8726')
      assert_body(args, {type: 'people', deletes: [{id: 344}], upserts: [{name: 'jessica'}, {name: 'leto'}]})
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Documents.bulk('people', [{name: 'jessica'}, {name: 'leto'}], [{id: 344}]).code).to eq(201)
  end
end
