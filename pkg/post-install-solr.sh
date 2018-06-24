#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo ">> POST-INSTALL: Reloading systemd service definitions"
/usr/bin/systemctl daemon-reload

echo ">> POST-INSTALL: Restarting Solr"
/usr/bin/systemctl restart solr.service
