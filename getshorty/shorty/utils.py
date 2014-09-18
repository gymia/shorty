from django.http import HttpResponse
from django.core.validators import URLValidator
from django.core.exceptions import ValidationError
import re, json, string, random

from shorty.models import ShortURL

def shortcode_is_valid(shortcode):
    reg = re.compile('^[0-9a-zA-Z_]{4,}$')
    return reg.match(shortcode) != None


def url_is_valid(url):
    val = URLValidator()
    try:
        val(url)
        return True
    except ValidationError, e:
        #Handled at the user level
        return False


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


def JsonResponse(data, status_code):
    return HttpResponse(json.dumps(data), content_type="application/json", status=status_code)