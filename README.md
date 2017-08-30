# Exercise: DNS Record Manager API

For this exercise, we are going to be implementing a RESTful API for managing DNS records, the kind of service one could imagine being used behind the scenes at a DNS hosting service.

A client of this API should be able to create and delete zones, view and manage all of the records within a zone.

Expect this exercise to take **roughly 3 hours**.

## General Requirements

Much of the implementation will be left to you.  However, the following requirements should be observed:

* Built using Ruby on Rails
* SQLite as data store
* RESTful endpoints
* JSON responses
* Appropriate test coverage

## Application Requirements

The API will expose two main resource endpoints: **Zone** and **Record**.

### Zone

* Has a name, which must be a valid domain name.
* Each Zone can contain multiple records.


### Record

A Record will expose the following information:

* Name
* Record Type
* Record Data
* TTL

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
