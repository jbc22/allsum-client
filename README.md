# allsum-client

* {Homepage}[http://rubygems.org/gems/allsum-client]
* {Documentation}[http://rubydoc.info/gems/allsum-client/frames]
* {Source}[https://github.com/jbc22/allsum-client]

## Description

Allsum-Client is meant for computing checksums on the Windows Operating System, mainly for forensic and incident response purposes.
It will compute MD5, SHA1, SHA256 and FuzzyHashes of specified filetypes.
By default, these filetypes that are included are PE files (.exe and .dll).
Provide allsum-client with the root directory, and it will recursively find files of the included type, compute their checksums and store it in a database.

## Features

MD5, SHA1, SHA256 and FuzzyHash (CTPH)

SQL Logging

## Examples

``` > ruby allsum-client
```

## Requirements

## Install

``` shell
$ gem install allsum-client
```

## Copyright

Copyright (c) 2011 "J. Brett Cunningham"

See LICENSE.txt for details.

