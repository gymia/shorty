Shorty Challenge
================

The trendy modern question for developer inteviews seems to be, "how to create an url shortner". Not wanting to fall too far from the cool kids, we have a challenge for you!

## The Challenge

The challenge, if you choose to accept it, is to create a micro service to shorten urls, in the style that TinyURL and bit.ly made popular.

## Build on Ubuntu

Ruby

    $ sudo apt-get update
    $ sudo apt-get install git-core curl git
    $ command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    $ curl -L https://get.rvm.io | bash -s stable
    $ source ~/.rvm/scripts/rvm
    $ rvm install 2.3.0
    $ rvm use 2.3.0 --default
    $ ruby -v
    $ gem install bundler

Mongo

    $ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    $ echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
    $ sudo apt-get update
    $ sudo apt-get install -y mongodb-org

MongoDB should start automatically. If not, run the following command:

    $ sudo service mongod restart

Cloning the repo and starting the server

    $ git clone https://github.com/frankieleef/shorty.git
    $ cd shorty
    $ bundle install
    $ rackup # Or if you want to run it as a deamon, run rackup --daemonize

The server should start on ```http://localhost:3000```

## Testing

    $ rspec


-------------------------------------------------------------------------

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
