# Ymlator

Quick and dirty YAML pastebin that allows for editing key values in the browser

## Prerequisites

    PostgreSQL
    Ruby 1.9.3
    Bundler

## Getting Started

    $ git clone git@github.com:bjoerge/ymlator.git
    $ cd ymlator

    $ bundle install
    
    $ rake db:bootstrap
    $ unicorn
    
    Then go to http://localhost:8080
    
## Todo
    Write tests