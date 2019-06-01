FROM ruby:2.6.3-stretch

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs mysql-client
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
