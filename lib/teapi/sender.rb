require 'oj'
require 'uri'
require 'zlib'
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

    def request(method, resource, args = {}, ts = nil)
      url = "#{BASE_URL}#{resource}?ts=#{ts || Time.now.to_i}"
      args[:headers] = (args[:headers] || {}).merge({
        'Authorization' => sign(url, args),
      })
      if args[:body] != nil && args[:body].length > 1024 then
        args[:body] = gzip(args[:body])
        args[:headers]['Content-Encoding'] = 'gzip'
      end
      scheme = @configuration.secure ? "https" : "http"
      res = HTTParty.send(method, "#{scheme}://#{@configuration.host}#{url}", args)
      if res.code == 401 && res.parsed_response.include?('ts') && ts.nil?
        return request(method, resource, args, res.parsed_response['ts'])
      end
      res
    end

    def sign(url, args)
      data = url
      data += args[:body] if args.include?(:body)
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @configuration.sync_secret, data)
      "HMAC-SHA256 Credential=#{@configuration.sync_key},Signature=#{signature}"
    end

    def gzip(body)
      io = StringIO.new("w")
      gz = Zlib::GzipWriter.new(io)
      gz.write(body)
      gz.close
      io.string
    end
  end
end
