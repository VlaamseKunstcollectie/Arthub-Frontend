#!/bin/bash --login
source /usr/local/rvm/scripts/rvm
rvm use 2.3.1
cd /opt/project-blacklight
RAILS_SERVE_STATIC_FILES=true rails s --binding=127.0.0.1 -e production
