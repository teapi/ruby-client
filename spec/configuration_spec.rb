require 'spec_helper'

describe 'configurations' do
  it "provide default values" do
    assert_default_config :http_open_timeout, 10
    assert_default_config :http_read_timeout, 10
    assert_default_config :port, 443
    assert_default_is_nil :sync_key, :sync_secret, :host
  end

  it "allows values to be set" do
    assert_value_set :host, 'x1.teapi.io'
    assert_value_set :port, 80
    assert_value_set :http_open_timeout, 20
    assert_value_set :http_read_timeout, 15
    assert_value_set :sync_key, '12312312p98sldkj123'
    assert_value_set :sync_secret, '12kjd923kaks'
  end

  private
  def assert_default_config(option, value)
    expect(Teapi::Configuration.new.send(option)).to eq(value)
  end
  def assert_default_is_nil(*options)
    options.each do |option|
      expect(Teapi::Configuration.new.send(option)).to be_nil
    end
  end
  def assert_value_set(option, value)
    config = Teapi::Configuration.new
    config.send(:"#{option}=", value)
    expect(config.send(option)).to eq(value)
  end
end
