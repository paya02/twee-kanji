FROM ruby:2.6.3-stretch
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs mysql-client vim

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . .
CMD ["rails", "server", "-b", "0.0.0.0"]
