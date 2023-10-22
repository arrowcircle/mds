FROM node:18 AS nodejs
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn
ENV NODE_ENV=production
COPY . /app
SHELL ["/bin/bash", "-c"]
RUN ["yarn", "vite", "build"]

FROM ruby:3.2.2-slim-bullseye AS base

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    vim \
    ssh \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Add PostgreSQL to sources list
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main' 11 > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    --no-install-recommends \
    libpq-dev \
    postgresql-client-14 \
    cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

RUN mkdir -p /app

COPY Gemfile* /app

WORKDIR /app

RUN bundle install --jobs=10

COPY . /app

COPY --from=nodejs app/assets/builds /app/assets

RUN rails assets:precompile

SHELL ["/bin/bash", "-c"]

run ["bundle", "exec", "puma", "-c" "config/puma.rb"]