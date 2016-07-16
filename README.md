# Autochthon

A simple Sinatra app for managing translations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'autochthon', github: 'asok/autochthon
```

And then execute:

    $ bundle

## Usage

### Rails application with ActiveRecord backend

#### Setup backend

Add this to your Gemfile:

```rb
gem 'i18n-active_record',
    :git => 'git://github.com/svenfuchs/i18n-active_record.git',
    :require => 'i18n/active_record'
```

Create file `config/initializers/i18n_backend.rb` with content:

```rb
require 'i18n/backend/active_record'

I18n.backend = Autochthon.backend = Autochthon::ActiveRecord::Backend.new

Autochthon.mount_point = "your_mount_point"
```

Probably you will want to use memoize so you don't generate a bunch of queries to the translations table on each request:

```rb
require 'i18n/backend/active_record'

if I18n::Backend::ActiveRecord::Translation.table_exists?
  I18n.backend = Autochthon.backend = Autochthon::ActiveRecord::Backend.new
  I18n.backend.class.include(I18n::Backend::Memoize)
end

Autochthon.mount_point = "your_mount_point"
```

NOTE: this will not work when you have your web server running several ruby processes.
That is the process in which you'll update the translation will see the new value for it. But other requests might be served by another process which will have the old value.

#### Mount

Add this to the routes:

```rb
mount Autochthon::Web => Autochthon.mount_point, :as => 'autochthon''
```

Probably you will want to authenticate. In case you are using [devise](https://github.com/plataformatec/devise) you can do:

```rb
authenticate(:admin) do
  mount Autochthon::Web => '/autochthon', :as Autochthon.mount_point
end
```

#### Create table

Create the translations table:

```
rake autochthon:create
```

#### Import

You can import existing translations to the db:

```
rake autochthon:import
```

If you want to only import specific locales you can do so:

```
LOCALES="en,fr" rake autochthon:import
```

#### Filling missing translations via right click

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
