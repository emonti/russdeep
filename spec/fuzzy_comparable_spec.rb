require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ssdeep'

class TestFuzzyComparable
  include Ssdeep::FuzzyComparable

  def ssdeep
    '96:tQWAFF4IMtG6z4FEmYqGPUyukJM4kbqkTKL+LGw6b8f/EZMhJvybtSryfubB:tO4a68FZYqyG4w2+Bbzhpybg6u9'
  end
end

describe Ssdeep::FuzzyComparable do
  before :all do
    @obj = TestFuzzyComparable.new
  end

  it "should compare itself to another fuzzy hash string" do
    @obj.fuzzy_score(Ssdeep.from_file sample_file("sample1.txt")).should == 100
    @obj.fuzzy_match(Ssdeep.from_file sample_file("sample1.txt")).should be_true
  end
end
