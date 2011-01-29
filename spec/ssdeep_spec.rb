require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ssdeep'

describe Ssdeep do
  before(:all) {
    @klass = Ssdeep

    @f1 = sample_file("sample1.txt")
    @f2 = sample_file("sample2.txt")

    @f1_hash = '96:tQWAFF4IMtG6z4FEmYqGPUyukJM4kbqkTKL+LGw6b8f/EZMhJvybtSryfubB:tO4a68FZYqyG4w2+Bbzhpybg6u9'
    @f2_hash = '192:sO4a68FZYqyG4w2+Bbzhpybg6uTI6l7yrnUxioPmSKx/A0IV2vRqtJUF2CnHqVC2:sOf6aYqyG4w3ug6uTI6lQUxioOLx/AZt'
  }

  # this seems to really mess up java... go figure... homer says: stupid java!
  unless RUBY_PLATFORM =~ /java/
    it "should compare two hashes from file descriptors with the same file" do
      @klass.compare(
        @klass.from_fileno(File.new(@f1, 'r').fileno),
        @klass.from_fileno(File.new(@f1, 'r').fileno)
      ).should == 100
    end

    it "should compare two hashes from different file descriptors" do
      @klass.compare(
        @klass.from_fileno(File.new(@f1, 'r').fileno),
        @klass.from_fileno(File.new(@f2, 'r').fileno)
      ).should > 50
    end
  end

  it_should_behave_like 'the Ssdeep interface'
end
