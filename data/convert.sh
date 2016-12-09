#!/bin/bash
for file in ./3*.xml
do
  catmandu convert LIDO to JSON --fix lido-to-solr-msk.fix --array 0 < "$file" > out.json
  curl -X POST -H 'Content-Type: application/json' 'http://datahub_ubuntu:8983/solr/blacklight-core/update/json/docs' --data-binary @out.json
done
