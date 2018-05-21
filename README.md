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

# when ~/.rbmaas/rbmaas.yml is configured
con = Maas::Client::MaasClient.new()

# when manually configuring
con = Maas::Client::MaasClient.new("#{CONSUMER_KEY}:#{KEY}:#{SECRET}",
"http://#{IP_OR_DOMAIN_NAME}/MAAS/api/2.0")


con.request(:get, ['users'])

con.request(:get, ['users'], {'op' => 'whoami'})

con.request(:post, ['users'], {'username' => 'someone1',
                               'email' => 'someone1@example.com',
                               'password' => 'maasuser1',
                               'is_superuser' => 1})

con.request(:get, ['account'], {'op' => 'list_authorisation_tokens'})

con.request(:post, ['account'], {'op' => 'create_authorisation_token', 'name' => 'mynewkey1'})

con.request(:post, ['account'], {'op' => 'delete_authorisation_token', 'token_key' => KEY})

con.request(:get, ['dnsresources'])

con.request(:get, ['ipaddresses'])

myarr = []
dns_records = con.request(:get, ['dnsresources'])
dns_records.each_with_index { |item, index| myarr << item['fqdn'] }
myarr

```
```bash
# to generate hosts file
rbmaas generate hosts

# to disused resources
rbmaas clear

# to initialize MAAS as defined in a yaml file
rbmaas init -f maas.yml
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

# Install RVM.
# https://rvm.io/rvm/install
$ echo progress-bar >> ~/.curlrc && curl -sSL https://get.rvm.io | bash

# It depends on your development environment. See following thread if it does not work.
# https://askubuntu.com/questions/121073/why-bash-profile-is-not-getting-sourced-when-opening-a-terminal
$ source ~/.bash_profile

# Download source.
$ git clone https://github.com/itisnotdone/maas-client.git

# This should install and create the ruby version and gemset specified at .ruby-version and .ruby-gemset.
$ cd maas-client

$ bundle

```

### To run simple tests with mocks

```bash

$ rspec

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
$ API_KEY='API_KEY' MAAS_SERVER='IP_OR_DOMAIN' rspec

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
vi lib/maas/client/version.rb
# and increase release number.

$ git add $things

$ git commit -m 'blahblah'

$ rake release

rake release --trace
** Invoke release (first_time)
** Invoke build (first_time)
** Execute build
maas-client x.x.xx built to pkg/maas-client-x.x.xx.gem.
** Invoke release:guard_clean (first_time)
** Execute release:guard_clean
** Invoke release:source_control_push (first_time)
** Execute release:source_control_push
Tagged vx.x.xx.
Username for 'https://github.com': $id
Password for 'https://id@github.com': 
Pushed git commits and tags.
** Invoke release:rubygem_push (first_time)
** Execute release:rubygem_push
Pushed maas-client x.x.xx to rubygems.org.
** Execute release

```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

