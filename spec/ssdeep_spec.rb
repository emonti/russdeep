require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ssdeep do
  before(:all) {
    @f1 = sample_file("sample1.txt")
    @f2 = sample_file("sample2.txt")

    @f1_hash = '96:tQWAFF4IMtG6z4FEmYqGPUyukJM4kbqkTKL+LGw6b8f/EZMhJvybtSryfubB:tO4a68FZYqyG4w2+Bbzhpybg6u9'
    @f2_hash = '192:sO4a68FZYqyG4w2+Bbzhpybg6uTI6l7yrnUxioPmSKx/A0IV2vRqtJUF2CnHqVC2:sOf6aYqyG4w3ug6uTI6lQUxioOLx/AZt'
  }

  it "should generate hashes for strings" do
    Ssdeep.from_string(File.read(@f1)).should == @f1_hash
    Ssdeep.from_string(File.read(@f2)).should == @f2_hash
  end

  it "should generate hashes from filenames" do
    Ssdeep.from_file(@f1).should == @f1_hash
    Ssdeep.from_file(@f2).should == @f2_hash
  end

  it "should generate hashes for file descriptor numbers" do
    Ssdeep.from_fileno(File.new(@f1, 'r').fileno).should == @f1_hash
    Ssdeep.from_fileno(File.new(@f2, 'r').fileno).should == @f2_hash
  end

  it "should compare two hashes from the same string correctly" do
    Ssdeep.compare(
      Ssdeep.from_string(File.read @f1),
      Ssdeep.from_string(File.read @f1)
    ).should == 100
  end

  it "should compare two hashes from the same string correctly" do
    Ssdeep.compare(
      Ssdeep.from_file(@f1),
      Ssdeep.from_file(@f1)
    ).should == 100
  end

  it "should compare two hashes from the same string correctly" do
    Ssdeep.compare(
      Ssdeep.from_fileno(File.new(@f1, 'r').fileno),
      Ssdeep.from_fileno(File.new(@f1, 'r').fileno)
    ).should == 100
  end

  it "should compare two hashes from the different strings correctly" do
    Ssdeep.compare(
      Ssdeep.from_string(File.read @f1),
      Ssdeep.from_string(File.read @f2)
    ).should > 50
  end

  it "should compare two hashes from different filenames correctly" do
    Ssdeep.compare(
      Ssdeep.from_file(@f1),
      Ssdeep.from_file(@f2)
    ).should > 50
  end

  it "should compare two hashes from different file descriptor numbers correctly" do
    Ssdeep.compare(
      Ssdeep.from_fileno(File.new(@f1, 'r').fileno),
      Ssdeep.from_fileno(File.new(@f2, 'r').fileno)
    ).should > 50
  end
end
