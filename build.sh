#!/bin/bash
echo "===== Installing packages ======="
sudo apt-get update
sudo apt-get install git-core curl build-essential libssl-dev libreadline-dev -y
sudo apt-get install libyaml-dev libsqlite3-dev sqlite3  python-software-properties software-properties-common -y
sudo apt-get install patch zlib1g-dev liblzma-dev -y
sudo apt-add-repository ppa:brightbox/ruby-ng -y
echo "#===== Installing Ruby ========"
sleep 2
sudo apt-get update
sudo apt-get install ruby2.4 ruby2.4-dev -y
sudo gem install bundler
sudo gem install nokogiri
echo "#====== Installing Gems ======"
bundle install
rake db:create
rake db:migrate
rake db:migrate RACK_ENV=test
