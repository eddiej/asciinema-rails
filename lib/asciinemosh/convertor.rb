require 'json'
require 'asciinema/asciicast'
require 'asciinema/asciicast_frames_file_updater'


module Asciinemosh
  class Convertor
    def self.to_infile(sudosh_timing_file_location, sudosh_script_file_location, original_terminal_cols=180, original_terminal_rows=43)
      timings = []
      byte_offsets = []
      File.open(sudosh_timing_file_location) do |f|
        f.each_line.each do |line|
          split = line.split(' ')
          timings << split[0].to_f
          byte_offsets << split[1].to_i
        end
      end
      duration = timings.inject(:+)

      ## Read segments of the file, defined by the byte offsets in the timing file.
      stdout = []
      File.open(sudosh_script_file_location, 'rb') do |file|
        until file.eof?
          timestamp = '%.5f' % timings.shift.to_f
          terminal_chunk = file.read(byte_offsets.shift)
          stdout << [Float(timestamp), terminal_chunk]
        end
      end
  
      json = {version: 1, width: original_terminal_cols, height: original_terminal_rows, duration: duration}
      json[:stdout] = stdout 

      JSON.pretty_generate(json)
    end

    def self.to_outfile(infile_location)
      json = JSON.parse(File.read(infile_location))
      asciicast = Asciicast.new(json['width'], json['height'], json['duration'], infile_location)
      # asciicast.with_terminal
      AsciicastFramesFileUpdater.new.update(asciicast)
      return asciicast.stdout_frames
    end

  end
end