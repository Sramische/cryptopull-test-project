FROM ruby:2.3.3-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential
RUN mkdir /app
COPY Gemfile /app
COPY Gemfile.lock /app
WORKDIR /app

RUN bundle install
COPY . /app