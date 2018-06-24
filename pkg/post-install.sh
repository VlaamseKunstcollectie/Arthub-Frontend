#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

chmod +x /opt/project-blacklight/start.sh

echo ">> POST-INSTALL: Reloading systemd service definitions"
/usr/bin/systemctl daemon-reload

echo ">> POST-INSTALL: Stopping Solr and Blacklight"
/usr/bin/systemctl stop solr.service
/usr/bin/systemctl stop blacklght.service

echo ">> POST-INSTALL: Login as Blacklight user and perform tasks"

su - blacklight -s /bin/bash <<_EOF_

set -o errexit

cd \${HOME}

source /usr/local/rvm/scripts/rvm
rvm use 2.3.1

echo "Performing database migrations"
RAILS_ENV=production /opt/project-blacklight/bin/rake db:migrate

echo "Precompiling assets"
RAILS_ENV=production /opt/project-blacklight/bin/rake assets:precompile

exit 0
_EOF_

echo ">> POST-INSTALL: Start Solr and Blacklight"
/usr/bin/systemctl start solr.service
/usr/bin/systemctl start blacklight.service
