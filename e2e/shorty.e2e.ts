import restify = require('restify');
import chai = require('chai');
import chaiDatetime = require('chai-datetime');
import {Client} from 'restify';

chai.use(chaiDatetime);
let expect = chai.expect;

let client: Client;

describe('The shorty api', ()=> {
    const url = 'http://test.url';

    beforeEach(()=> {
        client = restify.createJsonClient(`http://localhost:3000`); // TODO: get port from config
    });

    it('shortens an url', (done)=> {
        client.post('/shorten', {url}, (err, req, res: restify.Response, data)=> {
            expect(res.statusCode).to.equal(201);
            expect(res.headers['content-type']).to.equal('application/json');
            expect(data).to.include.keys('shortcode');
            expect(data.shortcode).to.match(/^[0-9a-zA-Z_]{6}$/);

            client.get(`/${data.shortcode}`, (err, req, res: restify.Response)=> {
                expect(res.statusCode).to.equal(302);
                expect(res.headers['location']).to.equal(url);
                done();
            });
        });
    });

    it('returns an error when no url is provided', (done)=> {
        client.post('/shorten', {}, (err, req, res: restify.Response, data)=> {
            expect(res.statusCode).to.equal(400);
            expect(res.headers['content-type']).to.equal('application/json');
            expect(data.message).to.equal('url is not present');
            done();
        });
    });

    it('returns 404 on a non-existing shortcode', (done)=>{
        client.get('/shortcodethatdoesnotexist', (err, req, res: restify.Response)=>{
            expect(res.statusCode).to.equal(404);
            done();
        });
    });

    describe('when providing a desired code', ()=> {
        let doShortenRequest = function (body, callback) {
            client.post('/shorten', body, callback);
        };

        it('uses a valid code of minimal length', (done)=> {
            let shortcode = 'zoef';
            doShortenRequest({'url': 'http://test.url', shortcode}, (err, req, res: restify.Response, data)=> {
                expect(res.statusCode).to.equal(201);
                expect(data.shortcode).to.equal(shortcode);
                done();
            });
        });

        it('uses a valid code of extended length', (done)=> {
            let shortcode = '42istheanswer';
            doShortenRequest({'url': 'http://test.url', shortcode}, (err, req, res: restify.Response, data)=> {
                expect(res.statusCode).to.equal(201);
                expect(res.headers['content-type']).to.equal('application/json');
                expect(data.shortcode).to.equal(shortcode);
                done();
            });
        });

        it('rejects an invalid code', (done)=> {
            let shortcode = '123';
            client.post('/shorten', {
                'url': 'http://test.url',
                shortcode
            }, (err, req, res: restify.Response, data)=> {
                expect(res.statusCode).to.equal(422);
                expect(data.message).to.equal('The provided shortcode is invalid, it should match "/^[0-9a-zA-Z_]{4,}$/"');
                done();
            });
        });

        it('rejects an already existing code', (done)=> {
            let shortcode = 'usemeonce';
            client.post('/shorten', {'url': 'http://test.url', shortcode}, ()=> {
                client.post('/shorten', {
                    'url': 'http://test2.url',
                    shortcode
                }, (err, req, res: restify.Response, data)=> {
                    expect(res.statusCode).to.equal(409);
                    expect(data.message).to.equal('The desired shortcode is already in use.');
                    done();
                });
            });
        });
    });

    describe('when asked for stats', ()=> {
        let shortcode: string;
        let dateString: string;

        beforeEach(()=> {
            dateString = (new Date()).toISOString().substr(0, 10);
        });

        it('provides the data on a new shortcode', (done)=> {
            client.post('/shorten', {url}, (err, req, res: restify.Response, data)=> {
                shortcode = data.shortcode;

                client.get(`/${shortcode}/stats`, (err, req, res, data)=>{
                    expect(res.statusCode).to.equal(200);
                    expect(res.headers['content-type']).to.equal('application/json');

                    expect(data.startDate.substr(0,10)).to.equal(dateString);
                    expect(data.redirectCount).to.equal(0);
                    done();
                })
            });
        });

        it('updates the data when using a shortcode', (done)=> {
            client.post('/shorten', {url}, (err, req, res: restify.Response, data)=> {
                shortcode = data.shortcode;

                client.get(`/${shortcode}`, ()=>{
                    client.get(`/${shortcode}/stats`, (err, req, res, data)=>{
                        expect(res.headers['content-type']).to.equal('application/json');
                        expect(res.statusCode).to.equal(200);

                        expect(data.lastSeenDate.substr(0,10)).to.equal(dateString);
                        expect(data.redirectCount).to.equal(1);
                        done();
                    })
                });
            });
        });

        it('returns 404 on a non-existing shortcode', (done)=>{
            client.get('/shortcodethatdoesnotexist/stats', (err, req, res: restify.Response, data)=>{
                expect(res.statusCode).to.equal(404);
                done();
            });
        });
    });
});