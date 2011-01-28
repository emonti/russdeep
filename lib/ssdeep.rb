
if RUBY_PLATFORM =~ /java/
  require 'ssdeep_ffi'
else
  require 'ssdeep_native'
end

