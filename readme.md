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
Teapi::Documents.delete('people', 4)
```

More efficiently, bulk changes can be provided for a given type:

```ruby
# Create or update leto and jessica and delete the documents
# with ids 9, 29 and 23
Teapi::Documents.bulk('people',
  [
    {doc: {id: 4, name: 'leto atreides', power: 9001}},
    {doc: {id: 5, name: 'jessica atreides', power: 9201}}
  ],
  [{id: 9}, {id: 29}, {id: 23}]
)
```

Up to 1000 items can be inserted/updated and 1000 items deleted per call.

# Return and Exceptions
The teapi library is a thin wrapper around the HTTP library. Errors such as connection failures will result in an exception being raised, whereas trying to delete a non-existing document will result in a response being returned with a status `response.code` of 404 (and a [hopefully useful] JSON-encoded `response.body`).
