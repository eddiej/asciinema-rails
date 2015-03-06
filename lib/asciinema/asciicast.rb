require 'asciinema/terminal'
require 'asciinema/stdout'

class Asciicast


  attr_reader :terminal_columns, :terminal_lines, :duration, :file, :version
  attr_accessor :stdout_frames

  def initialize(terminal_columns, terminal_lines, duration, file_location)
    @terminal_columns = terminal_columns
    @terminal_lines = terminal_lines
    @duration = duration
    @file = File.new(file_location)
    @version = 1
  end

  


  def stdout
    return @stdout if @stdout
    @stdout = Stdout::Buffered.new(get_stdout)
  end

  def with_terminal
    terminal = Terminal.new(terminal_columns, terminal_lines)
    yield(terminal)
  ensure
    terminal.release if terminal
  end

  private 

  def get_stdout
    if version == 0
      Stdout::MultiFile.new(stdout_data.decompressed_path,
                            stdout_timing.decompressed_path)
    else
      Stdout::SingleFile.new(file.path)
    end
  end

end