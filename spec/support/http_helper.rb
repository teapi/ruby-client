module HttpHelper
  def setup_configuration(options)
    Teapi.configure do |config|
      options.each {|k,v| config.send(:"#{k}=", v)}
    end
    Teapi.configuration
  end

  def assert_body(args, expected)
    expect(args[:body]).to eq(Oj.dump(expected, mode: :compat))
  end

  def assert_auth(args, key, sig)
    expect(args[:headers]['Authorization']).to eq("HMAC-SHA256 Credential=#{key},Signature=#{sig}")
  end
end

class FakeResponse < Net::HTTPSuccess
  attr_accessor :code, :body

  def initialize(body, code = 200)
    @body = body
    @code = code
  end
end
