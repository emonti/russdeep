require 'spec_helper'

shared_examples_for 'the Ssdeep interface' do
  it "should generate hashes for strings" do
    @klass.from_string(File.read(@f1)).should == @f1_hash
    @klass.from_string(File.read(@f2)).should == @f2_hash
  end

  it "should generate hashes from filenames" do
    @klass.from_file(@f1).should == @f1_hash
    @klass.from_file(@f2).should == @f2_hash
  end

  it "should generate hashes for file descriptor numbers" do
    @klass.from_fileno(File.new(@f1, 'r').fileno).should == @f1_hash
    @klass.from_fileno(File.new(@f2, 'r').fileno).should == @f2_hash
  end

  it "should compare two hashes from the same string correctly" do
    @klass.compare(
      @klass.from_string(File.read @f1),
      @klass.from_string(File.read @f1)
    ).should == 100
  end

  it "should compare two hashes from the same string correctly" do
    @klass.compare(
      @klass.from_file(@f1),
      @klass.from_file(@f1)
    ).should == 100
  end

  it "should compare two hashes from the same string correctly" do
    @klass.compare(
      @klass.from_fileno(File.new(@f1, 'r').fileno),
      @klass.from_fileno(File.new(@f1, 'r').fileno)
    ).should == 100
  end

  it "should compare two hashes from the different strings correctly" do
    @klass.compare(
      @klass.from_string(File.read @f1),
      @klass.from_string(File.read @f2)
    ).should > 50
  end

  it "should compare two hashes from different filenames correctly" do
    @klass.compare(
      @klass.from_file(@f1),
      @klass.from_file(@f2)
    ).should > 50
  end

  it "should compare two hashes from different file descriptor numbers correctly" do
    @klass.compare(
      @klass.from_fileno(File.new(@f1, 'r').fileno),
      @klass.from_fileno(File.new(@f2, 'r').fileno)
    ).should > 50
  end

  
end
