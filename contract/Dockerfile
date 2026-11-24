# Draws parts and compares pictures.
FROM ruby:4.0.10-slim-trixie
RUN apt-get update && apt-get install -y --no-install-recommends build-essential libvips42t64 \
    && rm -rf /var/lib/apt/lists/* && gem install ruby-vips --version 2.3.0 --no-document
