FROM ruby:4.0.5

# Packages
RUN apt-get update && apt-get install -y curl build-essential libpq-dev libvips libvips-dev vim tree

ARG BUNDLER_VERSION=4.0.14

WORKDIR /tmp

# Bundler
RUN gem update --system ${BUNDLER_VERSION} --no-document && \
    gem install bundler -v ${BUNDLER_VERSION} --no-document

WORKDIR /app

# RubyGems
COPY .ruby-version Gemfile Gemfile.lock ./
ENV BUNDLE_GEMFILE=/app/Gemfile
ENV BUNDLE_PATH=/app/vendor/bundle
ENV BUNDLE_FROZEN=true
RUN bundle install

EXPOSE 3000
CMD ["bash"]
