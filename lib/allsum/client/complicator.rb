require "Win32API"
require "digest"
require "./client/logger"
require "ssdeep"

module Allsum
  module Client

    class Complicator
      @debug = true
      @verbose = true

    def self.filename(path)
    	@filename = Pathname.new(path).basename
    end

    def self.version_info(file)
      vsize=Win32API.new('version.dll', 'GetFileVersionInfoSize', ['P', 'P'], 'L').call(file, "") # "" was s
      #p vsize if @debug
      if (vsize > 0)
        result = ' '*vsize
        Win32API.new('version.dll', 'GetFileVersionInfo', ['P', 'L', 'L', 'P'], 'L').call(file, 0, vsize, result)
        rstring = result.unpack('v*').map{|s| s.chr if s<256}*''
        r = /FileVersion..(.*?)\000/.match(rstring)
        puts "FileVersion = #{r ? r[1] : '??' }" if @verbose || @debug
        @fileversion = r ? r[1] : '??'
      else
        puts "No Version Info"  if @verbose || @debug
      end
    end

    def self.calculate_checksums(file)
      begin
        puts "Filename: #{@filename}"
        puts "[x]calculating checksums" if @debug || @verbose
        #md5
        @md5digest = Digest::MD5.hexdigest(File.read(file))
        puts "  MD5 checksum: #{@md5digest}" if @debug || @verbose
        #sha1
        @sha1digest = Digest::SHA1.hexdigest(File.read(file))
        puts "  SHA1 checksum: #{@sha1digest}" if @debug || @verbose
        #sha256
        @sha256digest = Digest::SHA256.hexdigest(File.read(file))
        puts "  SHA256 checksum: #{@sha256digest}" if @debug || @verbose
  	    #fuzzy hash
  	    @fuzzyhash = Ssdeep::FuzzyHash.from_file(file)
  	    puts "  Fuzzy hash: #{@fuzzyhash}" if @debug || @verbose
      rescue Errno::EACCESS
        puts "Perrmission denied when attempting to read #{@filename}" if @debug || @verbose
      end
    end

    def self.file_type(path)
      puts "[x]checking file type" if @debug || @verbose
  	  @filetype = File.basename(path.downcase).split(".").last
    end

    def self.file_size(path)
      puts "[x]checking file size" if @debug || @verbose
  	  @filesize = File.size?(path)

  	  puts "Filesize: #{@filesize}" if @debug || @verbose
      @filepath = path
    end

    def self.log_to_db(file)
      # schema:  uid | file name | size | file type | product | version info | modification date | ms bulletin | build | md5 | sha1  | sha256 | comment(?)
  	  puts "[x]logging to database" if @debug || @verbose

  	  Allsum::Client::Logger.paper(@filename, @filetype, @md5digest, @sha1digest, @sha256digest, @filepath, @fuzzyhash,
  	    @fileversion, @filesize)
      end
    end

  end
end

