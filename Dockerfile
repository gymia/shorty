FROM crystallang/crystal

RUN apt-get update
RUN apt-get install -y git

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN crystal deps
RUN crystal build src/shorty.cr --release -o /usr/src/app/shorty
RUN chmod a+x shorty

EXPOSE 3000

ENTRYPOINT /usr/src/app/shorty -r redis --redis-host db --redis-port 6379
