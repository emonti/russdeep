
if ENV['RUSSDEEP_USE_FFI'] or RUBY_PLATFORM =~ /java/
  require 'ssdeep_ffi'
else
  require 'ssdeep_native'
end

