# AGCOD

[![Build Status](https://travis-ci.org/compwron/aws_agcod.svg?branch=master)](https://travis-ci.org/compwron/aws_agcod)
[![Gem Version](https://badge.fury.io/rb/aws_agcod.svg)](http://badge.fury.io/rb/aws_agcod)

Amazon Gift Code On Demand (AGCOD) API v2 implementation for distributing Amazon gift cards (gift codes) instantly in any denomination.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws_agcod'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_agcod

## Usage

#### Configure

```ruby
require "aws_agcod"

AGCOD.configure do |config|
  config.access_key = "YOUR ACCESS KEY"
  config.secret_key = "YOUR SECRET KEY"
  config.partner_id = "PARTNER ID"

  # The `production` config is important as it determines which endpoint
  # you're hitting.
  config.production = true  # This defaults to false.

  # Optionally, you can customize the URI completely.
  config.uri = "https://my-custom-agcod-endpoint.com"

  config.region  = "us-east-1" # default
  config.timeout = 30          # default
end
```

#### Create Gift Code/Card

```ruby
request_id = "test"
amount = 10
currency = "USD" # default to USD, available types are: USD, EUR, JPY, CNY, CAD
httpable = HTTP # or HTTParty- whatever library you're using that has .post
request = AGCOD::CreateGiftCard.new(httpable, request_id, amount, currency)

# When succeed
if request.success?
  request.claim_code # => code for the gift card
  request.gc_id # => gift card id
  request.request_id # => your request id
else
# When failed
  request.error_message # => Error response from AGCOD service
end
```

#### Cancel Gift Code/Card

```ruby
request_id = "test"
gc_id = "test_gc_id"
httpable = HTTP # or HTTParty- whatever library you're using that has .post
request = AGCOD::CancelGiftCard.new(httpable, request_id, gc_id)

# When failed
unless request.success?
  request.error_message # => Error response from AGCOD service
end
```

#### Get Gift Code/Card activities

```ruby
request_id = "test"
start_time = Time.now - 86400
end_time = Time.now
page = 1
per_page = 100
show_no_ops = false # Whether or not to show activities with no operation
httpable = HTTP # or HTTParty- whatever library you're using that has .post
request = AGCOD::GiftCardActivityList.new(httpable, request_id, start_time, end_time, page, per_page, show_no_ops)

if request.success?
  request.results.each do |activity|
    activity.status # => SUCCESS, FAILURE, RESEND
    activity.created_at
    activity.type
    activity.card_number
    activity.amount
    activity.error_code
    activity.gc_id
    activity.partner_id
    activity.request_id
  end
else
  request.error_message # => Error response from AGCOD service
end
```
## Contributing

1. Fork it ( https://github.com/[my-github-username]/aws_agcod/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
