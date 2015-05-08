require 'json'
require 'asciinema/asciicast'
require 'asciinema/asciicast_frames_file_updater'
require 'asciinema/asciicast_snapshot_updater'



module Asciinema
  module Rails
    class Convertor

      # Generate an asciicast from Sudosh log files.

      # *Params*:
      # - sudosh_timing_file_location: path to the Sudosh timing file
      # - sudosh_script_file_location: path to the Sudosh script file
      # - options: Additional options hash: 
      #   * +:original_terminal_cols+: width of the Sudosh session terminal
      #   * +:original_terminal_rows+: height of the Sudosh session terminal
      #   * +:outfile_location+: file to write output to
      # *Returns*:
      # - A File object pointing to the generated asciicast.

      def self.to_infile(sudosh_timing_file_location, sudosh_script_file_location, options = {})
        original_terminal_cols = options[:original_terminal_cols] || 180
        original_terminal_rows = options[:original_terminal_rows] || 43
        outfile_location = options[:outfile_location]
        
        timings = []
        byte_offsets = []

        # Split the sudosh timing file into individual time splits and data byte offsets.
        # When paired with the Sudosh data file, each time split can be though of as an animation 'frame'
        File.open(sudosh_timing_file_location) do |f|
          f.each_line.each do |line|
            split = line.split(' ')
            timings << split[0].to_f
            byte_offsets << split[1].to_i
          end
        end
        duration = timings.inject(:+) ## add all of the time splits to get the total duration
      
        # Split the script file into segments as defined by the byte offsets in the timing file.
        # TODO: Write stdout directly to file rather than into memory first.
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

        self.to_file(JSON.pretty_generate(json), outfile_location)
        
      end

      # Generate a playback file from an asciicast.

      # *Params*:
      # - infile_location: path to the asciicast file
      # - options: Additional options hash: 
      #   * +:outfile_location+: file to write the playback data to
      # *Returns*:
      # - An array containing:
      #   * the playback file content as a string
      #   * a snapshot string
      #   * a hash containing the original width (cols), height (rows) and duration of the asciicast.

      def self.to_outfile(infile_location, options = {})
        outfile_location = options[:outfile_location] # playback data will be written here

        json = JSON.parse(File.read(infile_location)) # load the asciicast data into a hash 
        asciicast = Asciicast.new(json['width'], json['height'], json['duration'], infile_location) # create an Asciicast object
        AsciicastFramesFileUpdater.new.update(asciicast, outfile_location) # set playback data in Asciicast object, write to file also
        AsciicastSnapshotUpdater.new.update(asciicast) # set snapshot data in Asciicast object.
        
        [asciicast.stdout_frames, ActiveSupport::JSON.encode(asciicast.snapshot), {width: json['width'], height: json['height'], duration: json['duration']} ]

      end

      private

      def self.to_file(content, outfile_location=nil)
        out_file = outfile_location.present? ? File.new(outfile_location) : Tempfile.new('outfile')
        File.open(out_file, "w") do |f|
          f.write(content)
        end
        out_file
      end
    end
    
  end
end