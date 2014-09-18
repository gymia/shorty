from django.test import TestCase

from shorty.models import ShortURL
import json

class ShortenerViewTestCase(TestCase):
    '''
    Testing various cases of the shortener view
    '''
    def test_malformed_json(self):
        '''
        Sending post request with invalid JSON - comma not needed, qute missing
        '''
        json_data = '''
        {
          "url: "http://example.com",
        }
        '''
        response = self.client.post('/shorten', json_data, content_type='application/json')
        err = json.loads(response.content)
        
        self.assertEqual(response.status_code, 400)
        self.assertEqual(err.get("error"), "Invalid JSON sent.")

    def test_wrong_parameters_json(self):
        '''
        Sending post request with wrong parameters
        '''
        json_data = '''
        {
          "something": "else"
        }
        '''
        response = self.client.post('/shorten', json_data, content_type='application/json')
        err = json.loads(response.content)
        
        self.assertEqual(response.status_code, 400)
        self.assertEqual(err.get("error"), "url is not present or is invalid")

    def test_invalid_url_json(self):
        '''
        Sending post request with invalid url
        '''
        json_data = '''
        {
          "url": "htp:/example.com"
        }
        '''
        response = self.client.post('/shorten', json_data, content_type='application/json')
        err = json.loads(response.content)
        
        self.assertEqual(response.status_code, 400)
        self.assertEqual(err.get("error"), "url is not present or is invalid")

    def test_valid_url_json(self):
        '''
        Sending post request with valid url without shortcode
        '''
        json_data = '''
        {
          "url": "http://en.wikipedia.org/wiki/Lion"
        }
        '''
        response = self.client.post('/shorten', json_data, content_type='application/json')
        res = json.loads(response.content)
        
        self.assertEqual(response.status_code, 201)
        self.assertEqual(len(res.get("shortcode")), 6)

    def test_valid_url_shortcode_json(self):
        '''
        Sending post request with valid url and shortcode
        '''
        json_data = '''
        {
          "url": "http://en.wikipedia.org/wiki/Lion",
          "shortcode": "lion"
        }
        '''
        response = self.client.post('/shorten', json_data, content_type='application/json')
        res = json.loads(response.content)
        
        self.assertEqual(response.status_code, 201)
        self.assertEqual(res.get("shortcode"), "lion")

        response = self.client.post('/shorten', json_data, content_type='application/json')
        res = json.loads(response.content)
        
        self.assertEqual(response.status_code, 409)
        self.assertEqual(res.get("error"), "The the desired shortcode is already in use. Shortcodes are case-sensitive.")

    def test_valid_url_invalid_shortcode_json(self):
        '''
        Sending post request with valid url and invalid shortcode
        '''
        json_data = '''
        {
          "url": "http://en.wikipedia.org/wiki/Lion",
          "shortcode": "12:"
        }
        '''
        response = self.client.post('/shorten', json_data, content_type='application/json')
        res = json.loads(response.content)
        
        self.assertEqual(response.status_code, 422)
        self.assertEqual(res.get("error"), 'The shortcode fails to meet the regex following regexp: ^[0-9a-zA-Z_]{4,}$')


class RedirectViewTestCase(TestCase):
    '''
    Testing redirect view
    '''
    def setUp(self):
        ShortURL.objects.create(shortcode="lion", url="http://en.wikipedia.org/wiki/Lion")

    def test_shortcode_exists(self):
        response = self.client.get('/lion', content_type='application/json')
        self.assertEqual(response.status_code, 302)

    def test_shortcode_doesnt_exists(self):
        response = self.client.get('/zebra', content_type='application/json')
        res = json.loads(response.content)
        self.assertEqual(response.status_code, 404)
        self.assertEqual(res.get("error"), 'The shortcode cannot be found in the system')


class StatsViewTestCase(TestCase):
    '''
    Testing stats view
    '''
    def setUp(self):
        ShortURL.objects.create(shortcode="lion", url="http://en.wikipedia.org/wiki/Lion")

    def test_shortcode_exists(self):
        response = self.client.get('/lion/stats', content_type='application/json')
        res = json.loads(response.content)
        self.assertEqual(res.get("startDate")     != None, True)
        self.assertEqual(res.get("redirectCount") != None, True)

        if res.get("redirectCount") > 0:
            self.assertEqual(res.get("lastSeenDate") != None, True) 
        else:
            self.assertEqual(res.get("lastSeenDate") == None, True)                        

        self.assertEqual(response.status_code, 200)

    def test_shortcode_doesnt_exists(self):
        response = self.client.get('/zebra/stats', content_type='application/json')
        res = json.loads(response.content)
        self.assertEqual(response.status_code, 404)
        self.assertEqual(res.get("error"), 'The shortcode cannot be found in the system')


