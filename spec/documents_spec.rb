require 'spec_helper'

describe 'documents' do
  include HttpHelper

  it "inserts a single document" do
    allow(Time).to receive(:now) { Time.at(1424959556) }
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents')
      assert_auth(args, 'over9000', 'bc7468116834daef4bd3e7d1c6498cd6da15a4112859b04131bee870407c7120')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:56 GMT')
      assert_body(args, {type: 'people', doc: {name: 'leto'}})
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Documents.create('people', {name: 'leto'}).code).to eq(201)
  end

  it "inserts a single document with meta" do
    allow(Time).to receive(:now) { Time.at(1424959556) }
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents')
      assert_auth(args, 'over9000', '3528af433da22cd3afff77c4f9ebb7b9a79bc8be2686223dc86442eabafc70bc')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:56 GMT')
      assert_body(args, {type: 'people', doc: {name: 'leto'}, meta: {name: 'l a'}})
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Documents.create('people', {name: 'leto'}, {name: 'l a'}).code).to eq(201)
  end

  it "updates a single document" do
    allow(Time).to receive(:now) { Time.at(1424959555) }
    expect(HTTParty).to receive(:put) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents')
      assert_auth(args, 'over9000!', '26414ed86ad279509edf3971d898eca716bcb0c833fe3b0ac1a62b037fb92b70')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:55 GMT')
      assert_body(args, {type: 'atreides', doc: {name: 'jessica'}})
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000!', sync_secret: 'dune', host: 'fake.teapi.io')
    expect(Teapi::Documents.update('atreides', {name: 'jessica'}).code).to eq(201)
  end

  it "updates a single document with meta" do
    allow(Time).to receive(:now) { Time.at(1424959555) }
    expect(HTTParty).to receive(:put) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents')
      assert_auth(args, 'over9000!', 'da15517e131868af1082774b892b4fa6628a15b060238b0075dd093127103970')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:55 GMT')
      assert_body(args, {type: 'atreides', doc: {name: 'jessica'}, meta: {name: 'j a'}})
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000!', sync_secret: 'dune', host: 'fake.teapi.io')
    expect(Teapi::Documents.update('atreides', {name: 'jessica'}, {name: 'j a'}).code).to eq(201)
  end

  it "deletes a single document" do
    allow(Time).to receive(:now) { Time.at(1424959555) }
    expect(HTTParty).to receive(:delete) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents')
      assert_auth(args, 'over9000!', '8f32750c4064022a9c0fdd57ac3d1f0e78bdf53fe59095a4a9e69ae29eeed75d')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:55 GMT')
      assert_body(args, {type: 'atreides', id: 545})
      FakeResponse.new('', 204)
    end
    configuration = setup_configuration(sync_key: 'over9000!', sync_secret: 'dune', host: 'fake.teapi.io')
    expect(Teapi::Documents.delete('atreides', 545).code).to eq(204)
  end

  it "gzips larger documents" do
    allow(Time).to receive(:now) { Time.at(1424959555) }
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents')
      assert_auth(args, 'over9000', '5130fb2dca1c48bc231e5ef18117c65cb98dffcd411e9844f9a7df30482ffbb2')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:55 GMT')
      assert_body(args, {type: 'people', doc: {name: 'a' * 1024}}, true)
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Documents.create('people', {name: 'a' * 1024}).code).to eq(201)
  end

  it "handles bulk requests" do
    allow(Time).to receive(:now) { Time.at(1424959555) }
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents')
      assert_auth(args, 'over9000', '145a73bf6ccd6a2bc490ac60ea4f52f0ea4a5b350836a593ec7b1d198a5292c3')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:55 GMT')
      assert_body(args, {type: 'people', deletes: [{id: 344}], upserts: [{name: 'jessica'}, {name: 'leto'}]})
      FakeResponse.new('', 201)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Documents.bulk('people', [{name: 'jessica'}, {name: 'leto'}], [{id: 344}]).code).to eq(201)
  end

  it "handles invalid timestamp response" do
    expect(HTTParty).to receive(:post) do |url, args|
      FakeResponse.new('{"error": "invalid timestamp", "date": "Thu, 26 Feb 2015 14:05:10 GMT"}', 401)
    end
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/documents')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:10 GMT')
      FakeResponse.new('', 200)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Documents.bulk('people', [{name: 'jessica'}, {name: 'leto'}], [{id: 344}]).code).to eq(200)
  end

  it "doesn't endlessly try to solve timestamp issues" do
    expect(HTTParty).to receive(:post) do |url, args|
      FakeResponse.new('{"error": "invalid timestamp", "date": "Thu, 26 Feb 2015 14:05:10 GMT"}', 401)
    end
    expect(HTTParty).to receive(:post) do |url, args|
      FakeResponse.new('{"error": "invalid timestamp", "date": "Thu, 26 Feb 2015 14:05:11 GMT"}', 401)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Documents.bulk('people', [{name: 'jessica'}, {name: 'leto'}], [{id: 344}]).code).to eq(401)
  end
end
