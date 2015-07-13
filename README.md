# Asciinema-Rails

TLDR: Record terminal sessions from local or remote machines and play them back from your own website. See the demo at [http://eddiej.github.io/asciinema-rails](http://eddiej.github.io/asciinema-rails).

Asciinema-rails is a gem that allows you to generate playback files from Asciinema asciicasts or Sudosh log files and host them from your own website using the bundled player.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'asciinema-rails'
```

And then execute:

    $ bundle install

Or install it manually:

    $ gem install asciinema-rails

## Prerequisites

Asciinema-rails gem depends on the binary `terminal` which must be compiled for your platform before using this gem. The source file `terminal.c` is located in the `/src` directory of the gem. Before compiling, you need to install a suitable version of the `libtsm` library for your platform. For Darwin based systems, a reliable source is 
[https://github.com/skade/libtsm](https://github.com/skade/libtsm). For other distributions, see [http://www.freedesktop.org/wiki/Software/kmscon/libtsm](http://www.freedesktop.org/wiki/Software/kmscon/libtsm).

Once `libtsm` has been installed, compile `terminal.c`:

    $ gcc -O3 -o terminal terminal.c -ltsm

The resulting binary file `terminal` should be placed in your binaries folder (e.g. `/usr/bin`), or added to the $PATH environment variable.


## Usage

Asciinema-rails consists of two parts - a Convertor module for creating player files, and an engine that provides the assets that allow you to playback the files from your own site.

### Asciinema::Rails::Convertor

Asciinema::Rails::Convertor has two methods, one to generate player files from Asciinema asciicast files, and another to covert Sudosh log files to the Asciinema asciicast format (which can then be used to create player files.)

#### Creating playback files from asciicasts
From within your Rails application or terminal, create playback files using the `asciicast_to_playback` function:

    Asciinema::Rails::Convertor.asciicast_to_playback(asciicast_path, {playback_path: '/path/to/playback/file'})

where `asciicast_path` is the path to the file created after running the Asciinema recorder and `playback_path` is the path to save the new file.

#### Creating asciicasts from Sudosh log files
To create a playback file from Sudosh log files, you must first covert them to the Asciinma asciicast format using the `sudosh_to_asciicast` function:

    Asciinema::Rails::Convertor.sudosh_to_asciicast(sudosh_timing_file_path, sudosh_script_file_path, {asciicast_path: /path/to/asciicast/file})

where `asciicast_path` is the path to save the new asciicast file. If the width and height of the Susodh session terminal are available, these values can be passed in as additional parameters so that the resulting player is the original size of the terminal session. Note that Playback files can be generated from the resulting asciicast using the `asciicast_to_playback` method above. 

### Rails Engine

To display a player from your app, you need to include the asciineama-rails javascript and stylesheet files in ```app/assets/javascripts/application.js```and ```app/assets/stylesheets/application.css respectively```:

##### application.js
    //= require asciinema-rails

##### application.css
    *= require asciinema-rails
 
Then include the player markup and javascript in any of your views:

    <div id='player-container'></div> <!-- the div that will contain the player -->

    <%= javascript_tag do %>
        asciinema.CreatePlayer(document.getElementById('player-container'), 80, 24, '/recording.json', 123.0, { speed: 1 })
    <% end %>

In this example, the Asciinema player file `recording.json` has been placed in the public directory of the app. This can be replaced with a fully qualified url, as long as it points to a player file.

The parameters sent to the `asciinema.Movie` constructor are the terminal width (cols), height (rows), playback file source, snapshot and playback speed. 
The width, height and snapshot string are returned form the `Asciinema::Rails::Convertor.asciicast_to_playback` method. Typically, player files would be associated with a Rails model, and this information would be saved as model fields when the playback files are generated.


## Testing
The test for the gem are written in Rspec:

    bundle exec rspec spec

## Demo
A demo of the player is available at [http://eddiej.github.io/asciinema-rails](http://eddiej.github.io/asciinema-rails). The embedded player shows a recording of the gem being installed and used in a new Rails application.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/asciinemosh/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
