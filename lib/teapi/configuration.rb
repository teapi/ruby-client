module Teapi
  class Configuration
    OPTIONS = [
      :sync_key, :sync_secret, :host, :port, :secure,
      :http_open_timeout, :http_read_timeout].freeze

    attr_accessor :sync_key, :sync_secret, :host, :port, :secure
    attr_accessor :http_open_timeout, :http_read_timeout

    def initialize
      @port = 443
      @secure = true
      @http_open_timeout = 10
      @http_read_timeout = 10
    end
  end
end
