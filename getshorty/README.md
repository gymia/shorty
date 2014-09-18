python manage.py makemigrations shorty
python manage.py migrate




### Console testing
```
curl --verbose -XPOST "http://localhost:8000/shorten" -H "Content-Type: application/json" -d'
{
    "url": "http://example.com",
    "shortcode": "example"                 
}'
```