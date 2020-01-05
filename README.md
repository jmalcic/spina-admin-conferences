# Conferences

[![Build Status](https://travis-ci.com/jmalcic/spina-conferences.svg?branch=master)](https://travis-ci.com/jmalcic/spina-conferences)
[![Test Coverage](https://codecov.io/gh/jmalcic/spina-conferences/branch/master/graph/badge.svg)](https://codecov.io/gh/jmalcic/spina-conferences)
[![Visual testing](https://percy.io/static/images/percy-badge.svg)](https://percy.io/Ulab/spina-conferences)
![Dependency updates](https://api.dependabot.com/badges/status?host=github&repo=jmalcic/spina-conferences)

*Conferences* is a plugin for [Spina](https://www.spinacms.com 'Spina website') (a [Rails](http://rubyonrails.org 'Ruby on Rails website') content management system) to add conference management functionality.
With the plugin, you'll be able to manage details of conferences, delegates, and presentations.
See the wiki for details of the types of data supported.

## Usage

The plugin will add a **Conferences** item to Spina's primary navigation menu.
The menu structure will then be as follows:

* *Other menu items*

* Conferences

    * Institutions
    
    * Conferences
    
    * Delegates
    
    * Presentations

After installing the plugin, you just need to start your server in the usual way:
```bash
$ rails s
```

## Installation

### From scratch

You'll need [Rails](http://rubyonrails.org 'Ruby on Rails website') installed if it isn't already.
Read how to do this in the [Rails getting started guide](https://guides.rubyonrails.org/getting_started.html 'Getting Started with Rails').

Then run:
```bash
$ rails new your_app --database postgresql
$ rails db:create
$ rails active_storage:install
```

Add this line to your application's Gemfile:

```ruby
gem 'spina'
```

And then execute:
```bash
$ bundle:install
```

Run the Spina install generator:
```bash
$ rails g spina:install
```

And follow the prompts.
Then follow the instructions below.

### For existing Spina installations

Add this line to your application's Gemfile:

```ruby
gem 'spina-conferences', github: 'jmalcic/spina-conferences'
```

You'll then need to install and run the migrations from Conferences (the Spina install generator does this for Spina).

First install the migrations and then migrate the database:
```bash
$ rake spina_conferences:install:migrations
$ rake db:migrate
```

### Configuring the main Rails app

Conferences requires a job queueing backend for import functionality, and you'll also want to cache pages listing
presentations, conferences, and so on. Read about this in the Rails guides covering
[Active Job](https://guides.rubyonrails.org/active_job_basics.html) and
[caching](https://guides.rubyonrails.org/caching_with_rails.html).

## Contributing

You're very welcome to contribute, particularly to translations.
If there's a bug, or you have a feature request, make an issue on GitHub first.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
