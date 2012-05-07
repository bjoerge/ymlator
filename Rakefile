$:.unshift(File.dirname(__FILE__))

require 'sinatra/activerecord/rake'

task :environment do
  require 'config/environment'
end

namespace :db do

  desc "bootstrap db user, recreate, run migrations"
  task :bootstrap do
    name = "ymlator"
    `createuser -sdR #{name}`
    `createdb -O #{name} #{name}_development`
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke
  end

  task :migrate => :environment do
    Rake::Task["db:structure:dump"].invoke
  end

  desc "nuke db, recreate, run migrations"
  task :nuke do
    name = "ymlator"
    `dropdb #{name}_development`
    `createdb -O #{name} #{name}_development`
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke
  end
end
