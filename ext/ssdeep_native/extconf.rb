require 'mkmf'
require 'rbconfig'

extension_name = "fuzzyhash_native"

dir_config(extension_name)

unless have_library("fuzzy") and
       find_header("fuzzy.h", "/usr/local/include")
  raise "You must install the ssdeep package"
end

create_makefile(extension_name)

