# Asciinemosh

Converts sudosh log files to asciinema format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'asciinemosh'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install asciinemosh

## Usage

    Asciinemosh::Convertor.to_infile(sudosh_timing_file_location, sudosh_script_file_location)

returns a JSON string in the correct format for upload to asciinema.org.

## Testing

    bundle exec rspec spec

## Contributing

1. Fork it ( https://github.com/[my-github-username]/asciinemosh/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
