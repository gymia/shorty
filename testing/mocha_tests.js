
const should = require('should'),
app = require('./../app.js'),
supertest = require('supertest'),
chai = require('chai'),


expect = require('chai').expect,
dburl = 'mongodb://localhost:27017/shorty';
var mongodb = require('mongodb');
var randomstring = require("randomstring");
var moment = require("moment");
var MongoClient = mongodb.MongoClient;

describe('integration_tests', function () {

	it('should empty the database', function (done) {
		MongoClient.connect(dburl, function(err, db){
			if (err) {
				done(err)    		
				return;
			}
			db.collection('urlList').remove(function(err, db) {
				if(err) {
					return done(err)
					
				} 
				return done()
				
			});
		});		
	});


	it('should post a new short url', function (done) {
		supertest(app)
		.post('/shorten').send({
			url : "http://www.google.com",
			shortcode : "12345"
		})
		.expect('Content-Type', /json/)
		.expect(201)
		.end(function (err, res) {
                
                res.body.shortcode.should.equal("12345");
                if (err) {
                	return done(err);                	
                } 
                return done();

            })
	});


	it('should post a new short url (2)', function (done) {
		supertest(app)
		.post('/shorten').send({
			url : "http://www.google.com",
			shortcode : "abcdef"
		})
		.expect('Content-Type', /json/)
		.expect(201)
		.end(function (err, res) {
                
                res.body.shortcode.should.equal("abcdef");                
                if (err) {
                	return done(err);                	
                } 
                return done();

            })
	});

	it('should post a new short url, check if generated url meets conditions', function (done) {
		supertest(app)
		.post('/shorten').send({
			url : "http://www.google.com"			
		})
		.expect('Content-Type', /json/)
		.expect(201)
		.end(function (err, res) {
                
                var test = /^[0-9a-zA-Z_]{6}$/.test(res.body.shortcode);
                test.should.equal(true);
                if (err) {
                	return done(err);                	
                } 
                return done();

            })
	});

	it('should fail to post invalid url', function (done) {
		supertest(app)
		.post('/shorten').send({
			url : "invalid"			
		})
		.expect('Content-Type', /json/)
		.expect(400)
		.end(function (err, res) {                                
                if (err) {
                	return done(err);                	
                } 
                return done();

            })
	});

	it('should fail to post existing shortcode', function (done) {
		supertest(app)
		.post('/shorten').send({
			url : "http://www.google.com",
			shortcode : "12345"
		})
		.expect('Content-Type', /json/)
		.expect(409)
		.end(function (err, res) {                                
                if (err) {
                	return done(err);                	
                } 
                return done();

            })
	});


	it('should fail to post invalid shortcode', function (done) {
		supertest(app)
		.post('/shorten').send({
			url : "http://www.google.com",
			shortcode : "123"
		})
		.expect('Content-Type', /json/)

		.expect(422)
		.end(function (err, res) {                                
                if (err) {
                	return done(err);                	
                } 
                return done();

            })
	});


	it('should get google.com for shortcode 12345', function (done) {
		supertest(app)
		.get('/12345')
		.expect('Content-Type', 'text/plain; charset=utf-8')
		.expect('location', 'http://www.google.com')
		.expect(302)
		.end(function (err, res) {                                
                if (err) {
                	return done(err);                	
                }                                 

                return done();

            })
	});

	it('should not find shortcode abcd', function (done) {
		supertest(app)
		.get('/abcd')		
		.expect(404)
		.end(function (err, res) {                                
                if (err) {
                	return done(err);                	
                }                                 

                return done();

            })
	});


	it('should find stats for shortcode 12345', function (done) {
		supertest(app)
		.get('/12345/stats')		
		.expect(200)
		.expect('Content-Type', /json/)
		.end(function (err, res) {                                
                if (err) {
                	return done(err);                	
                }                                 

                res.body.redirectCount.should.equal(1)
                return done();
            })
	});


	it('should find stats for shortcode abcdef', function (done) {
		supertest(app)
		.get('/abcdef/stats')		
		.expect(200)
		.expect('Content-Type', /json/)
		.end(function (err, res) {                                
                if (err) {
                	return done(err);                	
                }                                 

                res.body.redirectCount.should.equal(0)
                return done();
            })
	});	

});
