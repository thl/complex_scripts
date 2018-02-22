module ComplexScripts
  module CoreExtensions # :nodoc:
    module Fixnum
      VOWELS = [97, 101, 105, 111, 117, 65, 69, 73, 79, 85]
      SECONDARY_SUFFIXES = [3942, 3921] #sa, da
      SUFFIXES = [3906, 3908, 3921, 3923, 3926, 3928, 3936, 3938, 3939, 3942] #ga, nga, da, na, ba, ma, 'a, ra, la, sa
      PREFIXES = [3906, 3921, 3926, 3928, 3936] #ga, da, ba, ma, 'a
      def is_tibetan_letter?
        self >= 3904 && self <= 4035
      end
      
      def is_tibetan_digit?
        self >= 3872 && self <= 3897
      end
      
      def is_tibetan_single_letter?
        self >= 3904 && self <=3948
      end
      
      def is_secondary_suffix?
        SECONDARY_SUFFIXES.include? self
      end
      
      def is_suffix?
        SUFFIXES.include? self
      end
      
      def is_prefix?
        PREFIXES.include? self
      end
      
      def is_subfix?
        self>=4016 && self<=4019
      end
      
      def is_tibetan_alphanumeric?
        self.is_tibetan_letter? || self.is_tibetan_digit?
      end
      
      def is_tibetan_punctuation?
        self >= 3844 && self <= 3858
      end
      
      def is_vowel?
        VOWELS.include? self
      end
      
      def is_tibetan_vowel?
        self >= 3953 && self <= 3965
      end
      
      def subjoined_letter?
        self >= 3984 && self <= 4015
      end
      
      def root_of_subjoined_letter
        case self
        when 3984 then TibetanLetter.find(1)
        when 3985 then TibetanLetter.find(2)
        when 3986 then TibetanLetter.find(3)
        when 3988 then TibetanLetter.find(4)
        when 3989 then TibetanLetter.find(5)
        when 3990 then TibetanLetter.find(6)
        when 3991 then TibetanLetter.find(7)
        when 3992 then TibetanLetter.find(8)
        when 3999 then TibetanLetter.find(9)
        when 4000 then TibetanLetter.find(10)
        when 4001 then TibetanLetter.find(11) #da
        when 4003 then TibetanLetter.find(12) #na
        when 4004 then TibetanLetter.find(13) #pa
        when 4005 then TibetanLetter.find(14) #pha
        when 4006 then TibetanLetter.find(15) #ba
        when 4008 then TibetanLetter.find(16) #ma
        when 4009 then TibetanLetter.find(17) #tsa
        when 4010 then TibetanLetter.find(18) #tsha
        when 4011 then TibetanLetter.find(19) #dza
        when 4014 then TibetanLetter.find(21) #zha
        when 4015 then TibetanLetter.find(22) #za
        else nil
        end
      end
      
      def language_code
        range = ComplexScripts.character_within_unicode_range(self)
        range.nil? ? nil : UNICODE_RANGES[range][2]
      end
    end
  end
end
