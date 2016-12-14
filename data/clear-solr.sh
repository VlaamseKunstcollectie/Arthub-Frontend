#!/bin/bash
curl http://datahub_ubuntu:8983/solr/blacklight-core/update?commit=true -H "Content-Type: text/xml" --data-binary '<delete><query>*:*</query></delete>'
