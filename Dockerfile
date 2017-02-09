FROM ruby:2.4.0

WORKDIR /shorty
ADD . /shorty

RUN bundle install
