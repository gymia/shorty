from django.db import models

class ShortURL(models.Model):
    url           = models.CharField(max_length=2048)
    shortcode     = models.CharField(max_length=128, db_index=True, unique=True)
    startDate     = models.DateTimeField(auto_now_add=True)
    lastSeenDate  = models.DateTimeField(auto_now_add=True, auto_now=True)
    redirectCount = models.PositiveIntegerField(default=0)

    def get_stats(self):
        stats = {
            "startDate": self.startDate.isoformat(),
            "redirectCount": self.redirectCount
        }
        if self.redirectCount > 0:
            stats["lastSeenDate"] = self.lastSeenDate.isoformat()
        return stats

    def save(self, *args, **kwargs):
        if self.pk:
            self.redirectCount += 1           
        super(ShortURL, self).save(*args, **kwargs)

    def __repr__(self):
        return "<%s : %s>" % (self.shortcode, self.url)
        