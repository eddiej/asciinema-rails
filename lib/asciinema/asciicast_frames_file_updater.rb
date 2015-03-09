require 'tempfile'
require 'asciinema/json_file_writer'
require 'asciinema/film'

class AsciicastFramesFileUpdater

  def initialize(file_writer = JsonFileWriter.new)
    @file_writer = file_writer
  end

  def update(asciicast, new_outfile_location)
    file = File.new(new_outfile_location, 'w')

    asciicast.with_terminal do |terminal|
      film = Film.new(asciicast.stdout, terminal)
      file_writer.write_enumerable(file, film.frames)
    end
    asciicast.stdout_frames = file
  end

  private

  attr_reader :file_writer

end
