module ComplexScripts
  module CoreExtensions # :nodoc:
    module Fixnum
      VOWELS = [97, 101, 105, 111, 117]
      def is_tibetan_letter?
        self >= 3904 && self <= 4035
      end
      
      def is_tibetan_digit?
        self >= 3872 && self <= 3897
      end
      
      def is_tibetan_alphanumeric?
        self.is_tibetan_letter? || self.is_tibetan_digit?
      end
      
      def is_vowel?
        VOWELS.include? self
      end
      
    end
  end
end
