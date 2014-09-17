from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt

import random, string, json

from shorty.utils import url_is_valid, shortcode_is_valid, shortcode_doesnt_exist, get_short_code
from shorty.utils import JsonResponse
from shorty.models import ShortURL



@csrf_exempt
def shorten(request):
    msg409 = "The the desired shortcode is already in use. Shortcodes are case-sensitive."
    msg400 = "url is not present or is invalid"
    msg422 = "The shortcode fails to meet the regex following regexp: ^[0-9a-zA-Z_]{4,}$"

    if request.method == 'POST':
        try:
            data = json.loads(request.body)
        except:
            #Invalid JSON recieved
            pass

        url       = data.get('url')
        shortcode = data.get('shortcode')

        if url and url_is_valid(url):
            if shortcode:
                if shortcode_doesnt_exist(shortcode) and shortcode_is_valid(shortcode):
                    su = ShortURL(shortcode=shortcode, url=url)
                    su.save()
                    return JsonResponse(su.get_stats(), 201)
                else:
                    if not shortcode_doesnt_exist(shortcode):
                        return JsonResponse({'error': msg409}, 409)
                    else:
                        return JsonResponse({'error': msg422}, 422)
            else:
                shortcode = get_short_code()
                su = ShortURL(shortcode=shortcode, url=url)
                su.save()
                return JsonResponse(su.get_stats(), 201)
        else:
            return JsonResponse({'error': msg400}, 400)

    #Handle /shorten as a GET
    return HttpResponse("Hello")