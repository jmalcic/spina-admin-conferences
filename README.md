# Collect

*Collect* is a plugin for [Spina](https://www.spinacms.com 'Spina website') (a [Rails](http://rubyonrails.org 'Ruby on Rails website') content management system) to add conference management functionality.
With the plugin, you'll be able to manage details of conferences, delegates, and presentations.
See the wiki for details of the types of data supported.
The plugin also includes three extra page parts for Spina pages: `Spina::Date`, `Spina::Url`, and `Spina::EmailAddress`.
`Spina::Url` and `Spina::EmailAddress` both have validators for the format of HTTP(S) URLs (using `URI`) and email addresses respectively.

## Usage

The plugin will add a **Conferences** item to Spina's primary navigation menu.
The menu structure will then be as follows:

* *Other menu items*

* Conferences
    
    * Conferences
    
    * Delegates
    
    * Presentations
    
You'll want to set up a conference first,
then delegates, which must belong to at least one conference,
and then presentations, which must belong to one conference and at least one delegate.

After installing the plugin, you just need to start your server in the usual way:
```bash
$ rails s
```

Make sure you choose 'Conference' as the theme.
You can choose the theme from the admin interface by going to **Preferences** &rarr; **Styling**.

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
gem 'collect'
```

You'll then need to install and run the migrations from Collect (the Spina install generator does this for Spina).

First install the migrations and then migrate the database:
```bash
$ rake collect_engine:install:migrations
$ rake db:migrate
```

### Configuring the main Rails app

Collect uses Opal, which makes use of ES6 syntax, 
so if you're using Uglifier, `:harmony` must be enabled when running the app in production.

```ruby
# config/environments/production.rb

# Other config code…

# Compress JavaScripts and CSS.
config.assets.js_compressor = Uglifier.new(harmony: true)
```

## Contributing

You're very welcome to contribute, particularly to translations.
If there's a bug, or you have a feature request, make an issue on GitHub first.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
