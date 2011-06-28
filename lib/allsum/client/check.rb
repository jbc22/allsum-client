# code reused by CF BILL (http://cf-bill.blogspot.com/2007/02/ruby-directory-traversal.html)
# and AShelly (http://stackoverflow.com/questions/76472/checking-version-of-file-in-ruby-on-windows)
# no use reinventing the wheel

require 'find'
require 'pathname'
require './client/complicator'
require './client/config'
require './client/models'
require './client/logger'
require 'yaml'

raw_config = File.read("../../allsum_config.yml")
CONFIG=YAML.load(raw_config)

@debug = true
@verbose = true
puts @rootDirectory = CONFIG["client"]["included"] if @debug
puts @excludedDirectoryNames = CONFIG["client"]["excluded"] if @debug
puts @includedFileTypes = CONFIG["client"]["filetypes"] if @debug
puts host = CONFIG["server"]["host"] if @debug
puts port = CONFIG["server"]["port"] if @debug
puts user = CONFIG["server"]["username"] if @debug
puts pass = CONFIG["server"]["password"] if @debug
puts table = CONFIG["server"]["table"] if @debug

Allsum::Client::Logger.new(host, port, user, pass, table, @debug, @verbose)

Allsum::Client::Models::Filename.new()
@rootDirectory.find.each do |gooddir|
  Find.find(gooddir) do |path|

    if FileTest.directory?(path)
      #determine if this is a directory we don't like...
      @excludedDirectoryNames.each do |baddir|
      if baddir.include?(File.basename(path.downcase))
        Find.prune #don't look in this directory
          puts "excluded directory #{path}" if @debug
        end
      end
    else #we have a file
      puts "we have a file #{path}" if @debug
	    filetype = Allsum::Client::Complicator.file_type(path)
      @includedFileTypes.each do |includeFile|
	      if includeFile.include?(filetype)
          puts path if @debug || @verbose
	      end
	      Allsum::Client::Complicator.filename(path)
	      Allsum::Client::Complicator.file_size(path)
	      Allsum::Client::Complicator.calculate_checksums(path)
        Allsum::Client::Complicator.version_info(path)
	      Allsum::Client::Complicator.log_to_db(path)
      end
    end
  end
end

