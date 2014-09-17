from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.core.validators import URLValidator
from django.core.exceptions import ValidationError

import random, string, json

from shorty.models import ShortURL


def shortcode_doesnt_exist(shortcode):
    return ShortURL.objects.filter(shortcode=shortcode).count() == 0

def get_new_code(size=6, chars=string.letters + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

def get_short_code():
    while True:
        c = get_new_code()
        if shortcode_doesnt_exist(c):
            break
    return c

@csrf_exempt
def shorten(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
        except:
            #Invalid JSON recieved
            pass

        url       = data.get('url')
        shortcode = data.get('shortcode')
        print url
        print shortcode

        if url:
            if shortcode:
                if shortcode_doesnt_exist(shortcode):
                    su = ShortURL(shortcode=shortcode, url=url)
                else:
                    pass
                    #greska postoji kod
            else:
                shortcode = get_short_code()
                print "nema shorta"

        else:
            #url not provided - err or invalid
            print "nema urla"

    #Handle /shorten as a GET
    return HttpResponse("Hello")