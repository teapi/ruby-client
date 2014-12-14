require 'teapi/version'
require 'teapi/configuration'
require 'teapi/documents'
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
    # @param [Symbol] resource name of the resource (:tags, :likes, ...)
    # @param [Hash] data data to send to the service
    def post(resource, data)
      sender.post(resource, data)
    end
  end
end
