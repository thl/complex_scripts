module ComplexScripts
  module CoreExtensions # :nodoc:
    module Fixnum
      def is_tibetan_letter?
        self >= 3904 && self <= 4035
      end
      
      def is_tibetan_digit?
        self >= 3872 && self <= 3897
      end
      
      def is_tibetan_alphanumeric?
        self.is_tibetan_letter? || self.is_tibetan_digit?
      end
    end
  end
end
