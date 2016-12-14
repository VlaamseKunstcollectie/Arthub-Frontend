#!/bin/bash
for file in ../msk-lido-data/*.xml
do
    echo "$file"
    iconv -f ISO-8859-1 -t UTF-8 "$file" > out.xml
    catmandu convert LIDO to JSON --fix lido-to-solr-msk.fix --array 0 < out.xml > out.json
    curl -X POST -H 'Content-Type: application/json' 'http://datahub_ubuntu:8983/solr/blacklight-core/update/json/docs?commit=true' --data-binary @out.json
done
