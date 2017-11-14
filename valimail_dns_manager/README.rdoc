A client of this API should be able to:

- create a zone
- delete a zone
- view and manage all of the records within a zone.

### Clean Architecture

The chosen approach was to implement the functionality using the Clean
Architecture pattern popularized by Robert Martin. Application business rules
reside in the under `lib/valimail/interactors` and are implemented using POROs
which are independent from the framework code.

![dep_rule](https://user-images.githubusercontent.com/8997/33102695-d2ad2282-ced2-11e7-9f92-835beb636476.png)
![layers](https://user-images.githubusercontent.com/8997/33102698-d51004a4-ced2-11e7-80de-d6868137420b.png)

Graphics provided by:
http://notes.lucida.me/2016/10/12/clean-architecture-on-android-notes/

### TODO

- The repoository patterns could be improved by removing the SQL logic and
injecting an `Adapter`, in this case a `SQLiteAdapter`. Additional `Adapters`
could be implmented to provide support for Mongo or Cassandra, e.g.
MongoAdapter, CassandraAdapter. This would allow entities to be peristed to
different database architectures by injecting a differnet `Adapter` into the
`Repoository`

- SQL statments could be separated into commands and queries

- Unit test coverage could be improved

### Zones resource

```
# The Zone name must be a domain name
#
# eg: example.com
```

#### Create zone
```
# POST   /zones
#   body: {
#     name: 'valimail.com'
#   }
#
```

#### Delete zone

```
# DELETE /zones/valimail.com
```

### Records resource

The data must have the following contraints:

* **Name**
	* Can be the Zone's root domain, indicated by a value of '@'.
	* Can be a subdomain value.
* **Record Type**
	* Will have a value of either **A** or **CNAME**
	* **A** Record Type
		*  Maps a domain to an IP address. The **Record Data** must then be a valid IPv4 address.
	* **CNAME** Record Type
		* Are pointers to other domains. The **Record Data** for a CNAME must then be a valid domain name.
* **TTL**
	* An integer representing the number of seconds a client would cache this record.

#### List records
```
# GET    /zones/valimail.com/records
```

#### Show record
```
# GET    /zones/valimail.com/records/@www
```

#### Create a record
```
# POST   /zones/valimail.com/records
#   body: {
#     name: '@mail'
#     type: 'A'
#     record_data: '127.0.0.1'
#     ttl:  '600'
#   }
```

```
# POST   /zones/valimail.com/records
#   body: {
#     name: '@mail'
#     type: 'CNAME'
#     record_data: 'google.com'
#     ttl:  '600'
#   }
```

#### Update a record
```
#
# PATCH  /zones/valimail.com/records/@mail
#   body: {
#     data: {
#       ttl:  '5'
#     }
#   }
```

#### Delete a record
```
# DELETE 127.0.0.1/zones/valimail.com/records/@www
```
