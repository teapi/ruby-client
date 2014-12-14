require 'oj'
require 'uri'
require 'openssl'
require 'httparty'

module Teapi
  class Sender
    BASE_URL = '/v1/'
    HEADERS = {'Accept' => 'application/json'}

    def initialize(configuration)
      @configuration = configuration
    end

    def request(method, resource, args = {})
      url = "#{BASE_URL}#{resource}?ts=#{Time.now.to_i}"
      args[:headers] = (args[:headers] || {}).merge({
        'Authorization' => sign(url, args),
        'Content-Encoding' => 'application/json'
      })
      scheme = @configuration.secure ? "https" : "http"
      HTTParty.send(method, "#{scheme}://#{@configuration.host}#{url}", args)
    end

    def sign(url, args)
      data = url
      data += args[:body] if args.include?(:body)
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @configuration.sync_secret, data)
      "HMAC-SHA256 Credential=#{@configuration.sync_key},Signature=#{signature}"
    end
  end
end
