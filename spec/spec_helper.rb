$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'support'))

Dir[File.join(File.dirname(__FILE__), '..', 'lib/*.rb')].each {|file| require file }
Dir[File.join(File.dirname(__FILE__), '..', 'lib/teapi/*.rb')].each {|file| require file }
Dir[File.join(File.dirname(__FILE__), 'support/*.rb')].each {|file| require file }

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:each) do
    allow(Time).to receive(:now) { Time.at(1424959555) }
    Teapi.configure do |config|
      config.sync_key = 'an_sync_key'
      config.sync_secret = 'the_api_shhh'
    end
  end
end
