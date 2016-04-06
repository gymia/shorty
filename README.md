## How to run with docker

```
$ docker-compose build
$ docker-compose up
```

## How to build on Ubuntu (ubuntu image on docker)

```
# Install requirements

$ sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
$ sudo echo "deb http://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
$ sudo apt-get update
$ sudo apt-get install crystal
$ sudo apt-get install redis-server
$ sudo apt-get install git gcc libgmp-dev libssl-dev libxml2-dev libyaml-dev curl

# Clone repo
$ cd ~
$ git clone https://github.com/umurgdk/shorty.git
$ git checkout crystal-implementation
$ cd shorty
$ crystal deps
$ crystal build src/shorty.cr --release
```

## Running tests and server on Ubuntu

```
# Run unit tests
$ crystal spec

# Run
$ redis-server &
$ ./shorty --repository redis # --redis-host localhost --redis-port 6379 &
$ curl -H "Content-Type: application/json" -X POST -d '{"url":"http://google.com"}' http://localhost:3000/shorten -v
```

## API Documentation

**All responses must be encoded in JSON and have the appropriate Content-Type header**


### POST /shorten

```
POST /shorten
Content-Type: "application/json"

{
  "url": "http://example.com",
  "shortcode": "example"
}
```

Attribute | Description
--------- | -----------
**url**   | url to shorten
shortcode | preferential shortcode

##### Returns:

```
201 Created
Content-Type: "application/json"

{
  "shortcode": :shortcode
}
```

A random shortcode is generated if none is requested, the generated short code has exactly 6 alpahnumeric characters and passes the following regexp: ```^[0-9a-zA-Z_]{6}$```.

##### Errors:

Error | Description
----- | ------------
400   | ```url``` is not present
409   | The the desired shortcode is already in use. **Shortcodes are case-sensitive**.
422   | The shortcode fails to meet the following regexp: ```^[0-9a-zA-Z_]{4,}$```.


### GET /:shortcode

```
GET /:shortcode
Content-Type: "application/json"
```

Attribute      | Description
-------------- | -----------
**shortcode**  | url encoded shortcode

##### Returns

**302** response with the location header pointing to the shortened URL

```
HTTP/1.1 302 Found
Location: http://www.example.com
```

##### Errors

Error | Description
----- | ------------
404   | The ```shortcode``` cannot be found in the system

### GET /:shortcode/stats

```
GET /:code
Content-Type: "application/json"
```

Attribute      | Description
-------------- | -----------
**shortcode**  | url encoded shortcode

##### Returns

```
200 OK
Content-Type: "application/json"

{
  "startDate": "2012-04-23T18:25:43.511Z",
  "lastSeenDate": "2012-04-23T18:25:43.511Z",
  "redirectCount": 1
}
```

Attribute         | Description
--------------    | -----------
**startDate**     | date when the url was encoded, conformant to [ISO8601](http://en.wikipedia.org/wiki/ISO_8601)
**redirectCount** | number of times the endpoint ```GET /shortcode``` was called
lastSeenDate      | date of the last time the a redirect was issued, not present if ```redirectCount == 0```

##### Errors

Error | Description
----- | ------------
404   | The ```shortcode``` cannot be found in the system


