FROM ruby:3.1.2-bullseye

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y   build-essential   nano   nodejs

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile* ./
RUN gem install bundler -v 2.3.22 && bundle install --jobs 20 --retry 5

RUN gem install foreman

COPY . /app
RUN rm -rf tmp/*

ADD . /app
