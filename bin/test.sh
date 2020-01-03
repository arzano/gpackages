#!/bin/bash

# Wait for Elasticsearch to start up
sleep 30

bundler install
yarn install --check-files
bundle exec rake tmp:create RAILS_ENV=test
bundle exec rake webpacker:compile RAILS_ENV=test
bundle exec rake kkuleomi:index:init RAILS_ENV=test
bundle exec rake kkuleomi:update:all RAILS_ENV=test

RAILS_ENV=test bundle exec rake test test/