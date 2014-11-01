#!/usr/bin/env bash

sudo apt-get install nodejs libxslt-dev libxml2-dev -y

gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

curl -sSL https://get.rvm.io | bash -s stable

source /usr/local/rvm/scripts/rvm

sudo /usr/local/rvm/bin/rvm requirements

rvm install 2.1.2
rvm use 2.1.2@uwc --create

cd /vagrant
bundle install
RAILS_ENV=development bundle exec rails s
