# Genki

[![Gem Version](https://badge.fury.io/rb/genki.svg)](https://badge.fury.io/rb/genki)

[![Build Status](https://travis-ci.org/genkirb/genki.svg?branch=master)](https://travis-ci.org/genkirb/genki)
[![Code Climate](https://codeclimate.com/github/genkirb/genki/badges/gpa.svg)](https://codeclimate.com/github/genkirb/genki)
[![Test Coverage](https://codeclimate.com/github/genkirb/genki/badges/coverage.svg)](https://codeclimate.com/github/genkirb/genki/coverage)

A fast and minimalist framework to generate APIs in Ruby.

Genki is a full-stack framework optimized for quick and easy creation of beautiful APIs.

## Usage

1. Install Genki:

        $ gem install genki --pre

  You only need `--pre`  while we are in beta.

2. Create a new Genki application:

        $ genki new app

3. Change directory to `app` and start the server:

        $ cd app
        $ genki server

You may run `genki help` for more information on the available commands.

### Controllers

Genki uses controllers to process requests. It differs from `rails`, as we don't enforce any directory structure (except having your files inside an `app` folder), and from `sinatra`, since we have a controller super class that should be inherited from.

To handle your requests you can simply create a class that inherits from `Genki::Controller` and place it inside `app` folder and it will start processing the matching ones.

As per the following example:

```ruby
# app/home.rb
class Home < Genki::Controller

  get '/' do
    #params will be available at `params`
    render 'Hello World'
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/genkirb/genki. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
