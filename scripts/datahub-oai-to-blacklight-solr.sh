#!/bin/bash

# USAGE  ./datahub-oai-to-blacklight-solr.sh http://datahub_ubuntu:8000/oai/
# Fix script for MSK data datahub-oai-to-blacklight-solr.fix should be in this directory, transforms LIDO to data readable by Project Blacklight
# Config for the Project Blacklight Solr instance "blacklightsolr" should be defined in catmandu.yml file in this directory

if [ -z "$1" ]
  then
    echo "Usage: please supply the URL of the Datahub OAI instance as an argument"
    exit 0
fi

OAI_URL=$1

catmandu import OAI --url $OAI_URL --metadataPrefx oai_lido --handler lido --fix datahub-oai-to-blacklight-solr.fix to blacklightsolr
