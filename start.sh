#!/bin/bash --login
source /usr/local/rvm/scripts/rvm
rvm use 2.3.1
cd /opt/project-blacklight
rails s
