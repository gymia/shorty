FROM ubuntu:14.04

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update\
 && apt-get install -y wget\
 && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb\
 && dpkg -i erlang-solutions_1.0_all.deb\
 && apt-get update\
 && apt-get install -y esl-erlang elixir\
 && rm -rf /var/lib/apt/lists/*

ENV APP_HOME /app/
ENV PORT 3000
ENV MIX_ENV prod

ADD . $APP_HOME

WORKDIR $APP_HOME
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile

EXPOSE 3000

ENTRYPOINT ["mix", "shorty.server"]
