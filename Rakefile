# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

SolrWrapper.default_instance_options = {
    verbose: true,
    cloud: false,
    port: '8983',
    version: '7.3.1',
    instance_dir: 'solr',
    download_dir: 'tmp'
}

require 'solr_wrapper/rake_task'

Rails.application.load_tasks

