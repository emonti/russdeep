
if ENV['RUSSDEEP_USE_FFI'] or RUBY_PLATFORM =~ /java/
  require 'ssdeep_ffi'
else
  require 'ssdeep_native'
end

module Ssdeep
  # The FuzzyComparable module adds mixins for doing fuzzy hash comparisons.
  # To mix in the module your object must simply implement the 'ssdeep'
  # method, which should return a string containing a fuzzy CTPH hash.
  module FuzzyComparable
    # Returns a CTPH comparison score between this object and another's
    # fuzzy hash.
    #
    # @param String,Object other
    #   The hash string or other object to compare to. If other is not
    #   a string, it just needs to implement the 'ssdeep' method.
    #
    def fuzzy_score(other)
      other_hash=
        if other.is_a? String
          other
        elsif other.respond_to? :ssdeep
          other.ssdeep
        else
          raise(TypeError, "can't handle type for other: #{other.class}")
        end

      Ssdeep.compare(self.ssdeep, other_hash)
    end

    # Returns true/false whether the sample matches a CTPH (fuzzy hash)
    # with a score above a specified threshold
    #
    # @param String,Object other
    #   The hash string or other object to compare to. If other is not
    #   a string, it just needs to implement the 'ssdeep' method.
    #
    # @param Integer threshold
    #   The theshold above-which a match is considered true. If a threshold
    #   is supplied above 100, it is treated as 100.
    #
    # @return true,false
    #   Whether a match occurred.
    def fuzzy_match(other, threshold=25)
      return (fuzzy_score(other) >= [threshold, 100].min)
    end
  end

  class << self
    alias :hash_string :from_string
    alias :hash_file :from_file
    alias :hash_fileno :from_fileno
  end
end


