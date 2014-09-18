from django.test import TestCase

from shorty.models import ShortURL
from shorty.utils import shortcode_is_valid

class ShortyUtilsTestCase(TestCase):
    '''
    Testing utils functions
    '''
    def test_shortcode_is_valid(self):
        '''
        Testing the regex checker for the shortcode: '^[0-9a-zA-Z_]{4,}$'
        '''
        #just testing boundary cases

        #length < 4
        self.assertEqual(shortcode_is_valid("nnn"),False)

        #length == 4
        self.assertEqual(shortcode_is_valid("nnnn"),True)

        self.assertEqual(shortcode_is_valid("AbcdEfgh"),True)

        self.assertEqual(shortcode_is_valid("AbcdEfghXyZ"),True)
        self.assertEqual(shortcode_is_valid("AbcdEfghXyZ1234j929"),True)
        self.assertEqual(shortcode_is_valid("AbcdEfgh////notgood?"),False)

        self.assertEqual(shortcode_is_valid("_1_2_3_4_5_6_Z"),True)
