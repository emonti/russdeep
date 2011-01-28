$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ssdeep'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

def sample_file(fname)
  File.expand_path(File.join(File.dirname(__FILE__), "samples", fname))
end

