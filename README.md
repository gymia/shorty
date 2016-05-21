# SHORTY_API

This is microservice which is used to create shorten urls, in the style that TinyURL and bit.ly

### Prerequisite

1. Ubuntu Machine
2. Ruby > 2.2.4
3. MySQL(Ver 14.14 Distrib 5.6.24)
4. Git
5. Bundler gem

You can follow https://gorails.com/setup/ubuntu/14.04 link to setup Ruby, MySQL & Git on Ubuntu server. For installing `bundler` gem, you just need to execute `gem install bundler` but make sure you have successfully installed `ruby` on your machine.

### Steps to setup

1. Clone the repo using `git clone git@github.com:kuldeepaggarwal/shorty_api.git`
2. Change the directory to cloned repo.

```shell
$ cd shorty_api
```
3. Run `bundle install`
4. Set SHELL Variables(`SHORTY_API_DATABASE_USERNAME`, `SHORTY_API_DATABASE_PASSWORD`) using `export` command. Please read about more [here](https://www.digitalocean.com/community/tutorials/how-to-read-and-set-environmental-and-shell-variables-on-a-linux-vps). These are 2 environment variables that will be used by the application to make connection to MySQL.

**NOTE** Make sure mysql user must have Database creation rights.

```sh
$ export SHORTY_API_DATABASE_PASSWORD=root
$ export SHORTY_API_DATABASE_USERNAME=root
```
5. Setup database using `rake db:create db:migrate` command
6. Run Rails Server using `bundle exec rails s` command. It will start rails server on http://localhost:3000.

### Testing

```shell
$ cd [path-to-project]
$ bundle install
$ RAILS_ENV=test bundle exec rake db:create db:migrate
$ RAILS_ENV=test bundle exec rspec spec
```

## API Documentation

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
