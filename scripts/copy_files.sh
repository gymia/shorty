#.bash

if [ -f "./config/redis.yml" ]
then
  echo "Redis config file exists"
else
  cp ./config/redis.yml.example ./config/redis.yml
fi

if [ -f ".rspec" ]
then
  echo "Rspec config file exists"
else
  cp ./.rspec.example ./.rspec
fi
