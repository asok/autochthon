# Autochthon

A simple Sinatra app for managing translations stored in YAML files, database or Redis.

Look at this as [localeapp](https://www.localeapp.com/) hosted in your application.

Video demonstration:

[![Video demonstration](http://img.youtube.com/vi/dOM3KTPEIEY/0.jpg)](https://youtu.be/dOM3KTPEIEY)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'autochthon'
```

## Usage

### Rails application with ActiveRecord backend

#### Setup backend

Add this to your Gemfile:

```rb
gem 'i18n-active_record', :require => 'i18n/active_record'
```

Create file `config/initializers/autochthon.rb` with content:

```rb
require 'i18n/backend/active_record'

I18n.backend = Autochthon.backend = Autochthon::Backend::ActiveRecord.new

Autochthon.mount_point = "your_mount_point"
```

Probably you will want to use memoize so you don't generate a bunch of queries on each request:

```rb
require 'i18n/backend/active_record'

if I18n::Backend::ActiveRecord::Translation.table_exists?
  I18n.backend = Autochthon.backend = Autochthon::Backend::ActiveRecord.new
  I18n.backend.class.include(I18n::Backend::Memoize)
end

Autochthon.mount_point = "your_mount_point"
```

NOTE: this will not work when you have your web server running several ruby processes.
That is the process in which you'll update the translation will see the new value for it. But other requests might be served by another process which will have the old value.
If that's the case consider:
* not using memoization
* caching the translation with an expiration option
* using redis backend without memoization

#### Create table

Create the translations table:

```
bundle exec rake autochthon:create
```

### Rails application with Redis backend

#### Setup backend

Add this to your Gemfile:

```rb
gem 'redis-i18n'
```

Create file `config/initializers/autochthon.rb` with content:

```rb
require 'i18n/backend/redis'

I18n.backend = Autochthon.backend = Autochthon::Backend::Redis.new

Autochthon.mount_point = "your_mount_point"
```

### Rails application with Simple (YAML) backend

NOTE: this backend operates in memory only. Meaning that your translations will not be persisted anywhere.

Create file `config/initializers/autochthon.rb` with content:

```rb
I18n.backend = Autochthon.backend = Autochthon::Backend::Simple.new

Autochthon.mount_point = "your_mount_point"
```

### Mount

Add this to the routes:

```rb
mount Autochthon::Web => Autochthon.mount_point, :as => 'autochthon''
```

Probably you will want to authenticate. In case you are using [devise](https://github.com/plataformatec/devise) you can do:

```rb
authenticate(:admin) do
  mount Autochthon::Web => '/autochthon', :as => Autochthon.mount_point
end
```

### Import

You can import existing translations from the I18n's simple backend (YAML files):

```
rake autochthon:import
```

If you want to only import specific locales you can do so:

```
LOCALES="en,fr" rake autochthon:import
```

### Filling missing translations via right click

In your `app/assets/javascripts/application.js` file do:

```js
//= require 'autochthon/application'
```

Now you can right click on the missing translations to fill them in.

## Examples

* rails application using ActiveRecord backend https://github.com/asok/autochthon_rails_example_app

## Development

In the dir `web/` run `npm install` fallowed by `npm run watch`.

That will compile the js files and put them in `public/bundle.js`.

Note: for a release you can run `npm run build`.

### Testing

`bundle exec rspec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asok/autochthon.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
