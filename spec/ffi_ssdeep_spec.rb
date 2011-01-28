require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ffi/ssdeep'

describe FFI::Ssdeep do
  before(:all) {
    @klass = FFI::Ssdeep
    @f1 = sample_file("sample1.txt")
    @f2 = sample_file("sample2.txt")

    @f1_hash = '96:tQWAFF4IMtG6z4FEmYqGPUyukJM4kbqkTKL+LGw6b8f/EZMhJvybtSryfubB:tO4a68FZYqyG4w2+Bbzhpybg6u9'
    @f2_hash = '192:sO4a68FZYqyG4w2+Bbzhpybg6uTI6l7yrnUxioPmSKx/A0IV2vRqtJUF2CnHqVC2:sOf6aYqyG4w3ug6uTI6lQUxioOLx/AZt'
  }

  it "should be using the FFI implementation" do
    FFI::Ssdeep.should respond_to(:fuzzy_compare)
    FFI::Ssdeep.should respond_to(:fuzzy_hash_file)
    FFI::Ssdeep.should respond_to(:fuzzy_hash_filename)
    FFI::Ssdeep.should respond_to(:fuzzy_hash_buf)
    FFI::Ssdeep.should respond_to(:fdopen)
  end

  it_should_behave_like 'the Ssdeep interface'

end
