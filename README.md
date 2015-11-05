# Spotrack

Make spot instance requests and watch them whether accepted or rejected

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spotrack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spotrack

## Usage

```bash
$ spotrack help
Commands:
  spotrack current                                       # Show current spot instance market price
  spotrack help [COMMAND]                                # Describe available commands or one specific command
  spotrack request                                       # Request spot instance(s)
  spotrack watch s, --spot-request-ids=SPOT_REQUEST_IDS  # Watch spot requests
```

### Show current spot instance market price (`spotrack current`)

```bash
$ spotrack help current
Usage:
  spotrack current

Options:
  a, [--availability-zone=AVAILABILITY_ZONE]  # Availability zone
  i, [--instance-type=INSTANCE_TYPE]          # Instance type
```

### Request spot instance(s) (`spotrack request`)

```bash
$ spotrack help request
Usage:
  spotrack request

Options:
  a, [--availability-zone=AVAILABILITY_ZONE]    # Availability zone
  i, [--instance-type=INSTANCE_TYPE]            # Instance type
  k, [--key-name=KEY_NAME]                      # The name of SSH key pair
  m, [--magnification=N]                        # The magnification of bidding price against current price
                                                # Default: 1.2
  n, [--numbers=N]                              # The number of instances
                                                # Default: 1
  g, [--security-group-ids=SECURITY_GROUP_IDS]  # List of security groups
  p, [--spot-price=N]                           # The bidding price
  b, [--subnet-id=SUBNET_ID]                    # The ID of subnets
```

### Watch spot request(s) (`spotrack watch`)

```bash
$ spotrack help watch
Usage:
  spotrack watch s, --spot-request-ids=SPOT_REQUEST_IDS

Options:
  s, --spot-request-ids=SPOT_REQUEST_IDS  # List of IDs of spot requests
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dtan4/spotrack. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
