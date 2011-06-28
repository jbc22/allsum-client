require 'dm-migrations'
require './client/models'

module Allsum
  module Client

    class Logger
  	  def self.new(host, port, user, pass, table, debug, verbose)
  	    @debug = debug
  		@verbose = verbose

  	  	@db = DataMapper.setup(:default, "mysql://#{user}:#{pass}@#{host}:#{port}/#{table}")
          puts @db if @debug

  	    DataMapper.finalize
  	    DataMapper.auto_upgrade!
  	  end


  	  def self.paper(file, filetype, md5digest, sha1digest, sha256digest, filepath, fuzzyhash, fileversion, filesize)

  	    puts "file #{file}" if @debug || @verbose
  	    puts filetype if @debug
  	    puts fileversion if @debug
  	    puts md5digest if @debug

  		begin
  	      saved = Allsum::Client::Models::Filename.create(
  		    :filename => file.to_s,
  		    :filetype => filetype.to_s,
  		    :created_at => Time.now,
  		    :size => filesize.to_i,
  		    :version => fileversion.to_s,
  		    :datemodified => Time.now,
  		    :filepath => filepath.to_s,
  		    :md5 => md5digest.to_s,
  		    :sha1 => sha1digest.to_s,
  		    :sha256 => sha256digest.to_s,
  			  :fuzzyhash => fuzzyhash.to_s
  		    )

  			#saved.save!

  			puts saved if @debug

  		  rescue DataObjects::IntegrityError
  		    puts "Already in DB" if @debug || @verbose
  		  end
  	  end

  	end
  end
end

