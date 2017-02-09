FROM ruby:2.4.0

COPY config/redis.yml.example /config/redis.yml
COPY .rspec.example .rspec

WORKDIR /shorty
ADD . /shorty

RUN bundle install
