require 'mkmf'
require 'rbconfig'

extension_name = "ssdeep_native"

dir_config(extension_name)

unless find_library("fuzzy", "fuzzy_hash_file", "/lib", "/usr/lib", "/usr/local/lib") and
       find_library("fuzzy", "fuzzy_hash_filename", "/lib", "/usr/lib", "/usr/local/lib") and
       find_library("fuzzy", "fuzzy_hash_buf", "/lib", "/usr/lib", "/usr/local/lib") and
       find_library("fuzzy", "fuzzy_compare", "/lib", "/usr/lib", "/usr/local/lib") and
       find_header("fuzzy.h", "/lib", "/usr/lib", "/usr/local/include")
  raise "You must install the ssdeep package"
end

create_makefile(extension_name)

