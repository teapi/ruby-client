require 'oj'
require 'uri'
require 'zlib'
require 'time'
require 'openssl'
require 'httparty'
require 'stringio'

module Teapi
  class Sender
    BASE_URL = '/v1/'
    HEADERS = {'Accept' => 'application/json'}

    def initialize(configuration)
      @configuration = configuration
    end

    def request(method, resource, args = {}, date = nil)
      url = BASE_URL + resource.to_s
      d = date || Time.now.utc.httpdate
      args[:headers] = (args[:headers] || {}).merge({
        'Date' => d,
        'Authorization' => sign(url, d, args),
      })
      scheme = @configuration.secure ? "https" : "http"
      res = HTTParty.send(method, "#{scheme}://#{@configuration.host}#{url}", args)
      if res.code == 401 && res.parsed_response.include?('date') && date.nil?
        return request(method, resource, args, res.parsed_response['date'])
      end
      res
    end

    def sign(url, date, args)
      data = url + date
      data += args[:body] if args.include?(:body)
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @configuration.sync_secret, data)
      "HMAC-SHA256 Credential=#{@configuration.sync_key},Signature=#{signature}"
    end
  end
end
