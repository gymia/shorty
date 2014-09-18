from django.test import TestCase

from shorty.models import ShortURL


class ShortURLModelTestCase(TestCase):
    '''
    Testing the behaviour of the DATABASE
    '''
    def setUp(self):
        ShortURL.objects.create(shortcode="lion", url="http://en.wikipedia.org/wiki/Lion")

    def test_get_by_shortcode(self):
        """ShortURL: Get URL by shortcode"""
        testurl = ShortURL.objects.get(shortcode="lion")
        self.assertEqual(testurl.url, "http://en.wikipedia.org/wiki/Lion")

    def test_get_by_url(self):
        """ShortURL: Get URL by shortcode"""
        testurl = ShortURL.objects.get(url="http://en.wikipedia.org/wiki/Lion")
        self.assertEqual(testurl.shortcode, "lion")

    def test_stats_created(self):
        """ShortURL: Check stats output just after creation"""
        testurl = ShortURL.objects.get(shortcode="lion")
        teststat = testurl.get_stats()

        self.assertEqual( teststat.get('redirectCount')         , 0)
        self.assertEqual( teststat.get('startDate')     !=  None, True)
        self.assertEqual( teststat.get('lastSeenDate')   == None, True)

    def test_stats_visited(self):
        """ShortURL: Check stats output just after first visit"""
        testurl = ShortURL.objects.get(shortcode="lion")
        testurl.save()

        self.assertEqual( testurl.get_stats().get('redirectCount')         , 1)
        self.assertEqual( testurl.get_stats().get('startDate')      != None, True)
        self.assertEqual( testurl.get_stats().get('lastSeenDate')   != None, True)

        testurl.save()
        self.assertEqual( testurl.get_stats().get('redirectCount')         , 2)

        testurl.save()
        self.assertEqual( testurl.get_stats().get('redirectCount')         , 3)