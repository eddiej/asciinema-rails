require 'asciinemosh'
require 'tempfile'

describe Asciinemosh::Convertor do
  # describe '.to_infile' do
  #   context 'with invalid arguments' do
  #     it "should raise an ArgumentError" do
  #       expect{ Asciinemosh::Convertor.to_infile }.to raise_error(ArgumentError)
  #     end
  #   end
  #   context 'with valid arguments' do
  #     before do
  #       @timing_file_location = "#{File.dirname(__FILE__)}/fixtures/sudosh-time"
  #       @script_file_location = "#{File.dirname(__FILE__)}/fixtures/sudosh-script"
  #       @output = Asciinemosh::Convertor.to_infile(@timing_file_location, @script_file_location, 180, 40)
  #     end
  #     it 'returns valid JSON output' do
  #       json_output = JSON.parse(@output)
        
  #       expect(json_output['version']).to eq 1
  #       expect(json_output['width']).to eq 180
  #       expect(json_output['height']).to eq 40
  #       expect(json_output['stdout'].length).to eq 21
  #     end
  #   end
  # end

   describe '.to_outfile' do
    context 'with valid arguments' do
      before do
        @timing_file_location = "#{File.dirname(__FILE__)}/fixtures/sudosh-time"
        @script_file_location = "#{File.dirname(__FILE__)}/fixtures/sudosh-script"
        @json = Asciinemosh::Convertor.to_infile(@timing_file_location, @script_file_location, 180, 40)
        
        out_file = Tempfile.new('outfile')
        File.open(out_file,"w") do |f|
          f.write(@json)
        end
        @output = Asciinemosh::Convertor.to_outfile(out_file.path, "/tmp/outilfe.json")
        out_file.unlink if out_file ## clean up

        puts JSON.parse(@json)['duration']

      end
      it "returns valid JSON output" do
        # puts @output.path
        # puts stdoutFile.read(@output.path)
      end
    end
  end
end
