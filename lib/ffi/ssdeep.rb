
require 'ffi'

module Ssdeep
  class HashError < StandardError
  end

  extend FFI::Library

  ffi_lib 'fuzzy'

  SPAMSUM_LENGTH = 64
  FUZZY_MAX_RESULT = (SPAMSUM_LENGTH + (SPAMSUM_LENGTH/2 + 20)) 

  typedef :pointer, :fuzzy_hash

  attach_function :fuzzy_hash_buf, [:pointer, :uint32, :fuzzy_hash], :int
  attach_function :fuzzy_hash_filen, [:pointer, :fuzzy_hash], :int
  attach_function :fuzzy_hash_filename, [:string, :fuzzy_hash], :int
  attach_function :fuzzy_compare, [:fuzzy_hash, :fuzzy_hash], :int

  attach_function :fdopen, [:int, :string], :pointer


  def self.from_string(buf)
    bufp = FFI::MemoryPointer.new(buf.size)
    bufp.write_string_length(buf, buf.size)

    out = FFI::MemoryPointer.new(FUZZY_MAX_RESULT)

    if (ret=fuzzy_hash_buf(bufp, bufp.size, out)) == 0
      return out.read_string
    else
      raise(HashError, "An error occurred hashing a string: ret=#{ret}")
    end
  end

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

  def self.from_file(filename)
    File.stat("/etc/foo")
    out = FFI::MemoryPointer.new(FUZZY_MAX_RESULT)

    if (ret=fuzzy_hash_filename(filename, out)) == 0
      return out.read_string
    else
      raise(HashError, "An error occurred hashing the file: #{filename} -- ret=#{ret}");
    end
  end

  def self.compare(sig1, sig2)
    psig1 = FFI::MemoryPointer.from_string(sig1)
    psig2 = FFI::MemoryPointer.from_string(sig2)

    return fuzzy_compare(psig1, psig2)
  end
end
