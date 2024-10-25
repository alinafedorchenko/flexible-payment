FROM ruby:3.1-bullseye as base

RUN mkdir /flexible-payment

WORKDIR /flexible-payment

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev nodejs

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

COPY . /flexible-payment
