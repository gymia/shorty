sudo apt-get install python-pip
sudo pip install Django
```
installs the last version (1.7)
```
cd shorty/getshorty

python manage.py makemigrations shorty
python manage.py migrate
python manage.py runserver

### Testing
python manage.py test

### Console testing
```
curl --verbose -XPOST "http://localhost:8000/shorten" -H "Content-Type: application/json" -d'
{
    "url": "http://example.com",
    "shortcode": "example"                 
}'
```