# teapi.io Ruby Library
This is a ruby driver for the <http://teapi.io> services.

# Installation

```ruby
gem install teapi
```

# Configuration
On startup, you'll want to setup your api key and secret:

```ruby
Teapi .configure do |config|
	# retrieve these values from the 'settings'
	# section of the management dashboard
	config.host =  'HOST'
	config.sync_key = 'KEY'
	config.sync_secret = 'SECRET'
end
```

Other available options are (with default):

```ruby
port (443)
http_open_timeout (10)
http_read_timeout (10)
```

# Usage
Documents can be created, updated or deleted one at a time:

```ruby
Teapi::Documents.create('people', {id: 4, name: 'leto atreides', power: 9001})
Teapi::Documents.update('people', {id: 4, name: 'leto atreides', power: 9002})
```
