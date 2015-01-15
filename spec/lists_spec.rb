require 'spec_helper'

describe 'lists' do
  include HttpHelper

  it "inserts a single list id" do
    allow(Time).to receive(:now) { Time.at(1424959556) }
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/lists')
      assert_auth(args, 'over9000', 'ee7536d6971104c36601da2e42f84b9c3ce0d5b26bc783faebeeedaaf8ffbe2c')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:56 GMT')
      assert_body(args, {type: 'people', list: 'newest', truncate: false, ids: [4]})
      FakeResponse.new('', 200)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Lists.insert('people', 'newest', 4).code).to eq(200)
  end

  it "inserts a single list array with truncate" do
    allow(Time).to receive(:now) { Time.at(1424959556) }
    expect(HTTParty).to receive(:post) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/lists')
      assert_auth(args, 'over9000', '77ecbb922efeb99b185d4a39c7e557aa4a9e16e09ff95bca900b30d066625ea8')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:56 GMT')
      assert_body(args, {type: 'people', list: 'newest', truncate: true, ids: ["abc", "123"]})
      FakeResponse.new('', 200)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Lists.insert('people', 'newest', ["abc", "123"], true).code).to eq(200)
  end

  it "deletes all list ids" do
    allow(Time).to receive(:now) { Time.at(1424959556) }
    expect(HTTParty).to receive(:delete) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/lists')
      assert_auth(args, 'over9000', 'ee5d35134c79272cec24a5e031ae2e112629dff2a5b2fb354387d4733a6230d7')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:56 GMT')
      assert_body(args, {type: 'people', list: 'newest', ids: nil})
      FakeResponse.new('', 200)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Lists.delete('people', 'newest').code).to eq(200)
  end

  it "deletes a single list ids" do
    allow(Time).to receive(:now) { Time.at(1424959556) }
    expect(HTTParty).to receive(:delete) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/lists')
      assert_auth(args, 'over9000', '36cd8780526ce6808b74eef3af809ebad59f4b89beaa3e1fac4f040f3fcc2fd7')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:56 GMT')
      assert_body(args, {type: 'people', list: 'newest', ids: [992]})
      FakeResponse.new('', 200)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Lists.delete('people', 'newest', 992).code).to eq(200)
  end

  it "deletes a multiple list ids" do
    allow(Time).to receive(:now) { Time.at(1424959556) }
    expect(HTTParty).to receive(:delete) do |url, args|
      expect(url).to eq('https://fake.teapi.io/v1/lists')
      assert_auth(args, 'over9000', '10b4e4749e817b5d07d100ad5b5ca226f4545f7d1e9bc9a72dba995eb15078ce')
      assert_date(args, 'Thu, 26 Feb 2015 14:05:56 GMT')
      assert_body(args, {type: 'people', list: 'newest', ids: ['a', 'b']})
      FakeResponse.new('', 200)
    end
    configuration = setup_configuration(sync_key: 'over9000', sync_secret: 'spice', host: 'fake.teapi.io')
    expect(Teapi::Lists.delete('people', 'newest', ['a', 'b']).code).to eq(200)
  end
end
