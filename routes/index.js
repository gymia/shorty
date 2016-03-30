var express = require('express');
var router = express.Router();
var mongodb = require('mongodb');
var randomstring = require("randomstring");
var moment = require("moment");
var MongoClient = mongodb.MongoClient;
var dburl = 'mongodb://localhost:27017/shorty';
 

const url_re = /^(https?:\/\/)?([\da-zA-Z\.-]+)\.([a-zA-Z\.]{2,6})([\/\w\.-]*)*\/?$/;
const shortcode_re = /^[0-9a-zA-Z_]{4,}$/;


router.get('/:shortcode/stats', function(req, res, next) {
	MongoClient.connect(dburl, function(err, db){
		if (err) {
			res.status(500).json(err)
			return;    		
		} 
		
		var collection = db.collection('urlList');

		collection.findOne({ "shortcode": req.params.shortcode } , function(err, item) {

			if(err) {
				res.status(500).json(err);
				db.close();
				return;
			}

			if(item){				
				res.status(200).json(
					{
						"startDate": item.startDate,
  						"lastSeenDate": item.lastSeenDate,
  						"redirectCount": item.redirectCount
  					});
			} else {
				res.status(404).send("The shortcode cannot be found in the system");
			}
			db.close();
		});
	});
});


router.get('/:shortcode', function(req, res, next) {
	MongoClient.connect(dburl, function(err, db){
		if (err) {
			res.status(500).json(err)
			return;    		
		} 

		
		var collection = db.collection('urlList');

		collection.findOne({ "shortcode": req.params.shortcode } , function(err, item) {

			if(err) {
				res.status(500).json(err);
				db.close();
				return;
			}

			if(item){				
				res.redirect(302, item.url);				

				collection.update(	{"shortcode" : req.params.shortcode}, 
									{
										$inc : {"redirectCount" : 1 },
										$set : {"lastSeenDate" : new Date() },
									});
			} else {
				res.status(404).send("The shortcode cannot be found in the system");
			}
			db.close();
		});
	});
})


router.post('/shorten', function(req, res, next){

    // Get a Mongo client to work with the Mongo server

    
    if(!req.body.url) {
    	res.status(400).json({url : 'url is not present'});
    	return;
    }
    var test = url_re.test(req.body.url);
    if(!test) {    	
    	res.status(400).json({url : 'url not correctly formatted'});
    	return;	
    }

    var shortcode = req.body.shortcode;        

    if(!shortcode) {
    	
    	shortcode = randomstring.generate(6);
    } else if(!shortcode_re.test(shortcode)) {
    	res.status(422).json({shortcode : 'shortcode does not meet criteria'})
    	return;
    }

    var newUrl = {
    	url: req.body.url, 
    	shortcode: shortcode,
    	startDate : new Date(),    	
    	redirectCount : 0
    };

    // Connect to the server
    MongoClient.connect(dburl, function(err, db){
    	if (err) {
    		res.status(500).json(err)
    		return;    		
    	} 

        // Get the documents collection
        var collection = db.collection('urlList');
        
        collection.findOne({ "shortcode": shortcode } , function(err, item) {

        	if(err) {
        		res.status(500).json(err);
        		db.close();
        		return;
        	}

        	if(item){
        		res.status(409).json({"shortcode": "already_in_use"})
        		db.close();
        		return;
        	} else {        		
        		collection.insert([newUrl], function (err, result){
        			if (err) {            
        				res.status(500).json(err)
        			} else {            
        				res.status(201).json({"shortcode" : shortcode});
        			}
        			db.close();
        		});    

        	}
        });                 

    });
});

module.exports = router;