# Arthub Flanders

A customised Project Blacklight installation for the 
[Arthub Flanders](https://arthub.vlaamsekunstcollectie.be) Project.

## Requirements

* Ruby ~>2.4 with Bundler ~>1.16
* Rails ~>5.1
* SQlite 3
* OpenJDK 8 (1.8)

## Installation

Get up and running (both blacklight and solr)

```
$ git clone https://github.com/VlaamseKunstcollectie/Arthub-Frontend frontend
$ cd frontend
$ bundle install
$ rake solr:clean
$ cp -R /vagrant/project-blacklight/solr-conf/blacklight-core /vagrant/project-blacklight/solr/server/solr
$ rake solr:start
$ rails server
```

Navigate to http://localhost:3000 to see the Arthub application in action. 

It's better to use a suitable proxy HTTP server instead of directly exposing 
the Rails server to the outside world. You can use either Apache or NGinx as a 
proxy. Configure NGinX like this:

```
server {

    listen 80;

    server_name blacklight.box;
    root /vagrant/project-blacklight;
    index index.php index.html index.htm;

    access_log /var/log/nginx/blacklight_project_access.log;
    error_log /var/log/nginx/blacklight_project_error.log error;

    location / {
        proxy_pass         http://127.0.0.1:3000/;
        proxy_redirect     off;

        proxy_set_header   Host             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    }
}
```

(Change the server_name and root directives to reflect the correct settings)

## Development

### Running a development server

Instead of running `rails server`, use `rails server -e development`. 

### Configuring Apache Solr

The entire Solr configuration is stored in the `solr` folder. Project 
Blacklight is configured to connect with Solr and use the `blacklight-core` 
core. The entire configuration can be found here:

```
/solr/server/solr/blacklight-core/conf/*
/solr/server/solr/blacklight-core/conf/solrconfig.xml
/solr/server/solr/blacklight-core/conf/schema.xml
```

Initial installation of Solr:

```
#!/bin/bash
rake solr:clean
cp -R /vagrant/project-blacklight/solr-conf/blacklight-core /vagrant/project-blacklight/solr/server/solr
rake solr:start
```

If you make changes to the configuration, you will need to restart your Solr 
instance and you may even have to delete your entire index. Use the script 
below to do this the brute force way. Save it in the root of the project.

```
#!/bin/bash
rake solr:stop
rm -r /solr/server/solr/blacklight-core/data/*
rake solr:start
```
## Production

### Asset compilation

This application uses the Asset Pipeline. Assets are stored in the 
`/app/assets` folder. In development mode, Rails will automagically compile
and store the assets in the `/public/assets` folder. However, in production 
mode, you will need to do things manually.

First you will need to manually pre-compile the assets. From the project 
root, run this command (assuming you use bundler).

```
$ RAILS_ENV=production bundle exec rake assets:precompile
```

This will create all the assetes and store them in the `/public/assets` folder.

**You will need to manually pre-compile all the assets when you perform a 
deployment to production**

## Asset serving configuration

The pre-compiled assets aren't served through rails but via the NGINX or 
Apache HTTP proxy. The configuration setting `config.public_file_server.enabled`
in `production.rb` needs to be set to `true` in order to make this happen.
If you don't do this, the assets won't be served properly and the layout of 
the appication will break. 

Set the environment variable `RAILS_SERVE_STATIC_FILES` in your `.bash_profile` 
file (or equivalent) accordingly:

```
export RAILS_SERVE_STATIC_FILES=true
```

## Set SECRET_KEY_BASE

The `secrets.yml` configuration file contains a salt per environment. You will 
need to set the production salt manually. From the project root, run this command:

```
$ rails secret
```

It will spit out a long hash. Copy the hash and add it to your `.bash_profile` 
file (or equivalent) as an environment vairbale:

```
export export SECRET_KEY_BASE="<HASH>"
```

Replace `<HASH>` with the generated hash.

## Run the production server

You are now set to run the production server:

```
$ rails s -e production
```

## Authors

* Matthias Vandermaesen matthias.vandermaesen@vlaamsekunstcollectie.be
* Tine Robbe tine.robbe@vlaamsekunstcollectie.be

## Copyright

Copyright 2016 - PACKED vzw, Vlaamse Kunstcollectie vzw

## License

This library is free software; you can redistribute it and/or modify it under 
the same terms as the license provided with [Project Blacklight](https://github.com/projectblacklight/blacklight/blob/master/LICENSE). 


