# Local

A simple Sinatra app for managing translations in the database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'local', github: 'asok/local'
```

And then execute:

    $ bundle

## Usage

### Standalone
  
Start the app using `LOCAL_DB_URI=sequel_connection_string rackup -p 1234`.
For `sequel_connection_string` see the Sequel's [documentation](http://sequel.jeremyevans.net/rdoc/classes/Sequel.html#method-c-connect).

You can now go to `http://localhost:1234` and browse/update translations.

Upon the first run the table `translations` will be created if not present.

### Rails application

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

I18n.backend = I18n::Backend::ActiveRecord.new
```

Probably you will want to use memoize so you don't generate a bunch of queries to the translations table on each request:

```rb
require 'i18n/backend/active_record'

I18n.backend = I18n::Backend::ActiveRecord.new
I18n.backend.class.include(I18n::Backend::Memoize)
```

#### Mount

Add this to the routes:

```rb
mount Local::Web => '/local', :as => 'local'
```

Probably you will want to authenticate. In case you are using [devise](https://github.com/plataformatec/devise) you can do: 

```rb
authenticate(:admin) do
  mount Local::Web => '/local', :as => 'local'
end
```

#### Create table

Create the translations table:

```
rake local:create
```

#### Import

You can import existing translations to the db:

```
rake local:import
```

If you want to only import specific locales you can do so:

```
LOCALES="en,fr" rake local:import
```

#### Update translations via right click

In the js manifest file that you include in your admin layout add this:

```
\\= require local
```

Now you can right click on the elements to create/update translations for them.

## Development

In the dir `web/` run `npm install` fallowed by `npm run watch`.

That will compile the js files and put them in `public/bundle.js`.

Note: for a release you can run `npm run build`.

### Testing

`bundle exec rspec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asok/local.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

