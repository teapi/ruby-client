module HttpHelper
  def setup_configuration(options)
    Teapi.configure do |config|
      options.each {|k,v| config.send(:"#{k}=", v)}
    end
    Teapi.configuration
  end

  def assert_body(args, expected, gzipped = false)
    body = args[:body]
    if gzipped then
      io = StringIO.new(body, "rb")
      gz = Zlib::GzipReader.new(io)
      body = gz.read
    end
    expect(body).to eq(Oj.dump(expected, mode: :compat))
  end

  def assert_auth(args, key, sig)
    expect(args[:headers]['Authorization']).to eq("HMAC-SHA256 Credential=#{key},Signature=#{sig}")
  end
end

class FakeResponse < Net::HTTPSuccess
  attr_accessor :code, :body, :parsed_response

  def initialize(body, code = 200)
    @body = body
    @parsed_response = Oj.load(body)
    @code = code
  end
end
