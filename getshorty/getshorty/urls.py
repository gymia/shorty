from django.conf.urls import patterns, include, url
#from django.contrib import admin

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'getshorty.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    #url(r'^admin/', include(admin.site.urls)),

    url(r'^shorten$',                               'shorty.views.shorten',       name='shorten'),
    url(r'^(?P<shortcode>[0-9a-zA-Z_]{1,})$',       'shorty.views.redirect',      name='redirect'),
    url(r'^(?P<shortcode>[0-9a-zA-Z_]{1,})/stats$', 'shorty.views.shorten_stats', name='shorten_stats'),
)
