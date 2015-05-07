# Asciinema-Rails

Converts sudosh log files to asciinema format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'asciinema-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install asciinema-rails

There is a binary file located in /bin that is used by the Terminal.rb class. This has been compiled for OSX (Yosemite). To compile it for your own platform, the source and Makefile is located in /src. You will need libtsm to be installed on your system (https://github.com/skade/libtsm is a good source for OSX).


## Usage

    Asciinema::Rails::Convertor.to_infile(sudosh_timing_file_location, sudosh_script_file_location)

returns a JSON string in the correct format for upload to asciinema.org.

## Host Your Own With Rails

Create a new rails application.
Follow the steps above under Installation.
Create an Asciinema player file:
a) From the output file of the Asciinema binary:

Asciinema::Rails::Convertor.to_outfile('/Users/eddiej/Rails/asciinemosh/recording', {outfile_location: '/tmp/recording.json'})

b) From a pair of Sudosh log files:

Include the asciienmosh assets:
in app/assets/javascripts/application.js - 

//= require asciinema-rails

in app/assets/stylesheets/applications.css

*= require asciinema-rails


// include player markup and javascript in any of your views:

```html
<div id='player-container'></div>

<%= javascript_tag do %>
  $(function() {
    function createPlayer() {
      var source = new asciinema.HttpArraySource("recording.json", 1);
      var snapshot = []
      var movie = new asciinema.Movie(180, 43, source, snapshot, 9);

      React.renderComponent(
        asciinema.Player({ autoPlay: true, movie: movie }),
        $('#player-container')[0]
      );
    }
    createPlayer();
  });
<% end %>
```

When a player file is generated by the gem by calling .asdsd
a static snapshot string is returned. This can be saved in a model field for instance, and used to show a preview of the video playback.



## Testing

    bundle exec rspec spec

## Contributing

1. Fork it ( https://github.com/[my-github-username]/asciinemosh/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
