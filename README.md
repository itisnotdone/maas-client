# Maas::Client

This is a simple client library for MAAS, Metal as a Service, written in Ruby.

## Installation

```ruby

$ bundle

# Or install it yourself as:

$ gem install maas-client --no-ri --no-rdoc

```

## Usage

```ruby

require "maas/client"

con = Maas::Client::MaasClient.new("#{CONSUMER_KEY}:#{KEY}:#{SECRET}",
"http://#{IP_OR_DOMAIN_NAME}/MAAS/api/2.0")


puts con.request(:get, "/users/")

puts con.request(:get, "/users/?op=whoami")

puts con.request(:post, "/users/", {"username" => "someone1",
                                    "email" => "someone1@example.com",
                                    "password" => "maasuser1",
                                    "is_superuser" => 1})

puts con.request(:get, "/account/?op=list_authorisation_tokens")

puts con.request(:post, "/account/?op=create_authorisation_token", {"name" => "mynewkey1"})

puts con.request(:post, "/account/?op=delete_authorisation_token", {"token_key" => "#{KEY}"})

puts con.request(:get, "/dnsresources/")

puts con.request(:get, "/ipaddresses/")

```

## Development and Contribution

Questions and pull requests are always welcome!

Source Repository
https://github.com/itisnotdone/maas-client

Gem Location
https://rubygems.org/gems/maas-client

Issues and questions
https://github.com/itisnotdone/maas-client/issues

### To begin contribution

```bash

$ sudo apt install git build-essential ruby ruby-dev

$ sudo gem update rake

$ git clone https://github.com/itisnotdone/maas-client.git

$ cd maas-client

$ bundle

```

### To run simple tests with mocks

```bash

$ bundle exec rspec

Maas::Client::MaasClient
  basic
    has a version number
    has an access token
    can report for wrong requests
  user list
    returns an array
    has user information
  user management
    can create a new user
    can delete a user

Finished in 0.01254 seconds (files took 0.17329 seconds to load)
7 examples, 0 failures

Coverage report generated for RSpec to /home/deploy/maas-client/coverage. 17 / 25 LOC (68.0%) covered.

```

### To run simple tests with real world

```bash
$ API_KEY='API_KEY' MAAS_SERVER='IP_OR_DOMAIN' bundle exec rspec

# if you want to see the report with Fivemat format
$ FIVEMAT_PROFILE=1; API_KEY='API_KEY' MAAS_SERVER='IP_OR_DOMAIN' bundle exec rspec

Maas::Client::MaasClient
  basic
    has a version number
    has an access token
    can report for wrong requests
  user list
    is an array
      has user information
  user management
    can create a new user
    can delete a user

Finished in 0.30954 seconds (files took 0.17286 seconds to load)
7 examples, 0 failures

Coverage report generated for RSpec to /home/deploy/maas-client/coverage. 25 / 25 LOC (100.0%) covered.
```

### To release

```bash

$ bundle exec rake release

# When bundler fails to load 'rake' command
$ bundle exec /usr/bin/rake release

```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

