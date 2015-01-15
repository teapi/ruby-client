require 'teapi/version'
require 'teapi/configuration'
require 'teapi/documents'
require 'teapi/lists'
require 'teapi/sender'

module Teapi #:nodoc
  class << self
    attr_accessor :sender
    attr_writer :configuration

    # Sets the configuration options.
    # Teapi.configure do |config|
    #   config.host = 'HOST'
    #   config.sync_key = 'KEY'
    #   config.sync_secret = 'SECRET'
    # end
    def configure
      yield(configuration)
      self.sender = Sender.new(configuration)
    end

    # Gets the current configuration
    def configuration
      @configuration ||= Configuration.new
    end

    # Issues a POST request to the teapi.io service
    # @param resource [Symbol] name of resource
    # @param body [String] to send to the service
    def post(resource, body)
      assert_configured()
      sender.request(:post, resource, {body: body})
    end

    # Issues a PUT request to the teapi.io service
    # @param resource [Symbol] name of resource
    # @param body [String] to send to the service
    def put(resource, body)
      assert_configured()
      sender.request(:put, resource, {body: body})
    end

    # Issues a DELETE request to the teapi.io service
    # @param resource [Symbol] name of resource
    # @param body [String] to send to the service
    def delete(resource, body)
      assert_configured()
      sender.request(:delete, resource, {body: body})
    end

    private
    def assert_configured()
      raise 'teapi invalid configuration' if @configuration.nil?
      raise 'teapi invalid sync_key' if @configuration.sync_key.nil?
      raise 'teapi invalid sync_secret' if @configuration.sync_secret.nil?
      raise 'teapi invalid host' if @configuration.host.nil?
    end
  end
end
