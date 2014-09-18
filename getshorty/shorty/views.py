from django.http import HttpResponse, HttpResponseRedirect
from django.views.decorators.csrf import csrf_exempt

import json

from shorty.utils import url_is_valid, shortcode_is_valid, shortcode_doesnt_exist, get_short_code
from shorty.utils import JsonResponse
from shorty.models import ShortURL


def redirect(request, shortcode):
    msg404 = "The shortcode cannot be found in the system"
    su = ShortURL.objects.filter(shortcode=shortcode).first()
    if su:
        su.save()
        return HttpResponseRedirect(su.url)
    else:
        return JsonResponse({'error': msg404}, 404)

def shorten_stats(request, shortcode):
    msg404 = "The shortcode cannot be found in the system"
    su = ShortURL.objects.filter(shortcode=shortcode).first()
    if su:
        return JsonResponse(su.get_stats(), 200)
    else:
        return JsonResponse({'error': msg404}, 404)

@csrf_exempt
def shorten(request):
    msg409 = "The the desired shortcode is already in use. Shortcodes are case-sensitive."
    msg400 = "url is not present or is invalid"
    msg422 = "The shortcode fails to meet the regex following regexp: ^[0-9a-zA-Z_]{4,}$"

    if request.method == 'POST':
        try:
            data = json.loads(request.body)
        except:
            return JsonResponse({'error': "Invalid JSON sent."}, 400)

        url       = data.get('url')
        shortcode = data.get('shortcode')

        if url and url_is_valid(url):
            if shortcode:
                if shortcode_doesnt_exist(shortcode) and shortcode_is_valid(shortcode):
                    su = ShortURL(shortcode=shortcode, url=url)
                    su.save()
                    return JsonResponse({"shortcode":su.shortcode}, 201)
                else:
                    if not shortcode_doesnt_exist(shortcode):
                        return JsonResponse({'error': msg409}, 409)
                    else:
                        return JsonResponse({'error': msg422}, 422)
            else:
                shortcode = get_short_code()
                su = ShortURL(shortcode=shortcode, url=url)
                su.save()
                return JsonResponse({"shortcode":su.shortcode}, 201)
        else:
            return JsonResponse({'error': msg400}, 400)

    #Handle /shorten as a GET
    return redirect(request, "shorten")