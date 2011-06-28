module Allsum
  module Client
    module Models

      class Filename
        require 'dm-migrations'
        include DataMapper::Resource

        property :id,           Serial, :key => true
        property :filename,     Text   # done
        property :filetype,     String   # needs work
        property :created_at,   DateTime # done
        property :datemodified, DateTime
        property :size,         Integer  # done
        property :version,      Text   # done
        property :filepath,     Text   # not done
        property :md5,          String # done
        property :sha1,         String # done
        property :sha256,       Text, :unique => true # done
        property :fuzzyhash,    Text #done

      end

    end
  end
end

