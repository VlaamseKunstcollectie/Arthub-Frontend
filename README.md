# README

Files that were changed from the original Project Blacklight install are

Solr configs:
jetty/solr/blacklight-core/conf/schema.xml
jetty/solr/blacklight-core/conf/solrconfig.xml

Catalog controller:
app/controllers/catalog_controller.rb

Static pages support:
app/controllers/pages_controller.rb
app/views/pages/about.html.erb
app/jobs/pages_helper.rb
test/controllers/pages_controller_test.rb

Routing for PIDs containing dots:
config/routes.rb

Customise home page:
app/views/catalog/_home_text_html.erb

Translation file:
config/locales/blacklight.en.yml

Datahub config:
config/datahub.yml
config/initializers/datahub.rb

Script to get data from the Datahub into Project Blacklight:
scripts/datahub-oai-to-blacklight-solr.sh
Fix script to convert this data to the right format:
scripts/datahub-oai-to-blacklight-solr.fix
Solr config for Catmandu for this script:
scripts/catmandu.yml
