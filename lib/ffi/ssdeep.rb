begin
require 'rubygems'
rescue LoadError
end

require 'ffi'

module FFI
module Ssdeep
  class HashError < StandardError
  end

  extend FFI::Library

  ffi_lib 'fuzzy'

  SPAMSUM_LENGTH = 64
  FUZZY_MAX_RESULT = (SPAMSUM_LENGTH + (SPAMSUM_LENGTH/2 + 20)) 

  typedef :pointer, :fuzzy_hash

  attach_function :fuzzy_hash_buf, [:pointer, :uint32, :fuzzy_hash], :int
  attach_function :fuzzy_hash_file, [:pointer, :fuzzy_hash], :int
  attach_function :fuzzy_hash_filename, [:string, :fuzzy_hash], :int
  attach_function :fuzzy_compare, [:fuzzy_hash, :fuzzy_hash], :int

  attach_function :fdopen, [:int, :string], :pointer


  # Create a fuzzy hash from a ruby string
  #
  # @param  String buf   The string to hash
  #
  # @return String       The fuzzy hash of the string
  #
  # @raise HashError  
  #   An exception is raised if the libfuzzy library encounters an error.
  def self.from_string(buf)
    bufp = FFI::MemoryPointer.from_string(buf.size)

    out = FFI::MemoryPointer.new(FUZZY_MAX_RESULT)

    if (ret=fuzzy_hash_buf(bufp, bufp.size, out)) == 0
      return out.read_string
    else
      raise(HashError, "An error occurred hashing a string: ret=#{ret}")
    end
  end

  # Create a fuzzy hash from a file descriptor fileno
  #
  # @param  Integer fileno  The file descriptor to read and hash
  # 
  # @return String          The fuzzy hash of the file descriptor input
  #
  # @raise HashError  
  #   An exception is raised if the libfuzzy library encounters an error.
  def self.from_fileno(fileno)
    if (not fileno.kind_of?(Integer)) or (file=fdopen(fileno, "r")).null?
      raise(HashError, "Unable to open file descriptor: #{fileno}")
    end

    out = FFI::MemoryPointer.new(FUZZY_MAX_RESULT)

    if (ret=fuzzy_hash_file(file, out)) == 0
      return out.read_string
    else
      raise(HashError, "An error occurred hashing the file descriptor: #{fileno} -- ret=#{ret}")
    end
  end

  # Create a fuzzy hash from a file
  #
  # @param  String fielname  The file to read and hash
  #
  # @return String           The fuzzy hash of the file input
  #
  # @raise HashError  
  #   An exception is raised if the libfuzzy library encounters an error.
  def self.from_file(filename)
    File.stat(filename)
    out = FFI::MemoryPointer.new(FUZZY_MAX_RESULT)

    if (ret=fuzzy_hash_filename(filename, out)) == 0
      return out.read_string
    else
      raise(HashError, "An error occurred hashing the file: #{filename} -- ret=#{ret}");
    end
  end

  # Compare two hashes
  #
  # @param String sig1  A fuzzy hash which will be compared to sig2
  #
  # @param String sig2  A fuzzy hash which will be compared to sig1
  #
  # @return Integer
  #   A value between 0 and 100 indicating the percentage of similarity.
  def self.compare(sig1, sig2)
    psig1 = FFI::MemoryPointer.from_string(sig1)
    psig2 = FFI::MemoryPointer.from_string(sig2)

    return fuzzy_compare(psig1, psig2)
  end
end
end
