#!/bin/bash
rake jetty:stop
rm -r ./jetty/solr/blacklight-core/data/*
rake jetty:start
#rake solr:marc:index MARC_FILE=./jetty/solr/blacklight-core/sample_marc_data.xml
