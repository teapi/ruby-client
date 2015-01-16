# teapi.io Ruby Library
This is a ruby driver for <http://teapi.io>.

# Installation

```ruby
gem install teapi
```

# Configuration
On startup, you'll want to setup your host, key and secret:

```ruby
Teapi.configure do |config|
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

A third, optional, parameter can be provided. This dictionary, internally called meta, is used for building indexes with values that aren't part of the document (or at least, aren't part of the document's data to be displayed by the API). For example:

```ruby
Teapi::Documents.create(
  'people',
  {id: 4, name: 'leto atreides', power: 9001},
  {active: true, power: 52334}
)
```

if indexes were created for `name`, `active` and `power`, Teapi would index the values `leto atreides`, `true` and `52334` respectively (notice that the meta value overwrites the document's value).

# Bulk Updates
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

Use the `meta` key for meta values:

```ruby
# Create or update leto and jessica and delete the documents
# with ids 9, 29 and 23
Teapi::Documents.bulk('people',
  [
    {doc: {id: 4, name: 'leto atreides', power: 9001}, meta: {...}},
    {doc: {id: 5, name: 'jessica atreides', power: 9201}, meta: {...}}
  ],
  [{id: 9}, {id: 29}, {id: 23}]
)
```

## Lists
Document ids can be pushed onto and removed from lists:

```ruby
Teapi::Lists.insert('people', 'newest', [1, 4, 992])
Teapi::Lists.delete('people', 'newest', 992)
```

For both `insert` and `delete`, the ids can either be a single value or an array (up to 1000 ids can be inserted / deleted at a time). You can also pass no ids to `delete`. This will remove all ids from the list:

```ruby
Teapi::Lists.delete('people', 'newest')
```

`insert` takes a 4th, optional, parameter: `truncate`. This defaults to `false`, but when set to true, it'll delete all existing ids then insert the newly provide one(s):

```ruby
// this will result in a list of only 1 id (99)
Teapi::Lists.insert('people', 'newest', 99, true)
```

# Return and Exceptions
The teapi library is a thin wrapper around the HTTP library. Errors such as connection failures will result in an exception being raised, whereas trying to delete a non-existing document will result in a response being returned with a status `response.code` of 404 (and a [hopefully useful] JSON-encoded `response.body`).
