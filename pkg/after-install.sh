systemctl daemon-reload
chmod +x /opt/project-blacklight/start.sh

su - blacklight -s /bin/bash
source /usr/local/rvm/scripts/rvm
rvm use 2.3.1
rake db:migrate RAILS_ENV=production
RAILS_ENV=production rake assets:precompile
exit
