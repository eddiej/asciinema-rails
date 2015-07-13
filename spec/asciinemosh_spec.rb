require 'spec_helper'
require 'asciinema-rails'
require 'tempfile'

describe Asciinema::Rails::Convertor do
  describe '.sudosh_to_asciicast' do
    context 'with invalid arguments' do
      it "should raise an ArgumentError" do
        expect{ Asciinema::Rails::Convertor.sudosh_to_asciicast }.to raise_error(ArgumentError)
      end
    end
    context 'with valid arguments' do
      before do
        @timing_file_location = "#{File.dirname(__FILE__)}/fixtures/sudosh-time"
        @script_file_location = "#{File.dirname(__FILE__)}/fixtures/sudosh-script"
        @outfile = Asciinema::Rails::Convertor.sudosh_to_asciicast(@timing_file_location, @script_file_location, {original_terminal_cols: 180, original_terminal_rows: 40})
      end
      it 'returns a File or Tempfile' do
        expect(@outfile).to respond_to(:close)
        expect(@outfile).to respond_to(:read)
      end
      it 'returns file with valid JSON' do
        json_output = JSON.parse(@outfile.read)
        
        expect(json_output['version']).to eq 1
        expect(json_output['width']).to eq 180
        expect(json_output['height']).to eq 40
        expect(json_output['stdout'].length).to eq 21
      end
    end
  end

   describe '.asciicast_to_playback' do
    context 'with valid arguments' do
      before do
        @timing_file_location = "#{File.dirname(__FILE__)}/fixtures/sudosh-time"
        @script_file_location = "#{File.dirname(__FILE__)}/fixtures/sudosh-script"
        
        infile = Asciinema::Rails::Convertor.sudosh_to_asciicast(@timing_file_location, @script_file_location, {original_terminal_cols: 180, original_terminal_rows: 40})
        @output = Asciinema::Rails::Convertor.asciicast_to_playback(infile.path, {outfile_location: '/tmp/index.json.erb'})
        
      end
      it "returns an array of three values" do
        expect(@output).to be_kind_of(Array) 
        expect(@output.length).to eq 3
      end
      it 'returns File or Tempfile as first argument' do
        file = @output[0]
        expect(file).to respond_to(:close)
        expect(file).to respond_to(:read)
      end
      it 'returns valid JSON as the second argument' do
        snapshot = @output[1]
        expect{ JSON.parse(snapshot)}.not_to raise_error    
      end
      it 'returns a hash as the third argument' do
        attributes = @output[2]
        expect(attributes).to be_kind_of(Hash) 
        expect(attributes.length).to eq 3
      end
    end
  end
end
