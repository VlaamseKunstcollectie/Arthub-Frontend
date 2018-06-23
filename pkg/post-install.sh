#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

chmod +x /opt/project-blacklight/start.sh

echo "Reloading systemd service definitions"
/usr/bin/systemctl daemon-reload

su - blacklight -s /bin/bash
cd "${HOME}"

source /usr/local/rvm/scripts/rvm
/usr/local/rvm/bin/rvm use 2.3.1

echo "Performing database migrations"
RAILS_ENV=production /opt/project-blacklight/bin/rake db:migrate

echo "Precompiling assets"
RAILS_ENV=production /opt/project-blacklight/bin/rake assets:precompile

exit 0
