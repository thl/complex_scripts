module ComplexScripts
  module CoreExtensions # :nodoc:
    module String
      
      # Takes a string and spans characters in predefined unicode ranges with xml:lang and class attribute with
      # language code (ISO 369-3) for easy rendering. Also converts characters outside ascii range into NCR.
      def span
        return self if blank?
        unicode_message = self.mb_chars
        return_string = ""
        i=0
        while i<unicode_message.length
          ch = unicode_message[i]
          ch_code = ch.ord
          if ch_code<=255
            return_string << ch
          else
            range = ComplexScripts.character_within_unicode_range(ch_code)
            if range.nil?
              return_string << "&##{ch_code};"
            else
              lang_code = UNICODE_RANGES[range][2]
              return_string << "<span lang=\"#{lang_code}\" xml:lang=\"#{lang_code}\" class=\"#{lang_code}\">"
              while i<unicode_message.length && range==ComplexScripts.character_within_unicode_range(ch_code=unicode_message[i].ord)
                return_string << "&##{ch_code};"
                i+=1
              end
              return_string << "</span>"
              next
            end
          end
          i+=1
        end
        return_string
      end      
      alias :s :span
      
      # converts chars outside ascii range to NCR, but does not span. To be used in forms (buttons, drop-down
      # lists, etc.).
      def encode
        return self if blank?
        unicode_message = self.mb_chars
        return_string = ""
        i=0
        while i<unicode_message.length
          ch = unicode_message[i]
          ch_code = ch.ord 
          if ch_code<=255
            return_string << ch
          else
            return_string << "&##{ch_code};"
          end
          i+=1
        end
        return_string
      end      
      alias :e :encode
      
      def base_letter(lang_code = nil)
        letter = self.lstrip.chars
        return nil if letter.blank?
        case lang_code
        when 'jee', 'wme', 'san'
          letter = letter.to(3)
          letter = letter.gsub(/-|=|_|\?|\/|\^|\342\211\241|\302\271|\302\262|\050/,'').lstrip.downcase # get rid of garbage that may precede head term
          return nil if letter.empty?
          return letter.to_s if letter.size==1
          if letter.at(1)=='h' && !"aeiou\304\201\305\253".include?(letter.at(0)) # last vowels are LATIN SMALL LETTER U WITH MACRON and LATIN SMALL LETTER A WITH MACRON
            letter = letter.to(1)
          else
            letter = letter.at(0)
          end
          #exceptions
          case letter.at(0)
          when "\303\230"
            return "\303\270" # LATIN CAPITAL LETTER O WITH STROKE -> SMALL
          when "\306\206"
            return "\311\224" # LATIN CAPITAL LETTER OPEN O -> SMALL
          when "\306\212"
            return "\311\227" # LATIN CAPITAL LETTER D WITH HOOK -> SMALL
          when "\341\271\204"
            return "\341\271\205" # LATIN CAPITAL LETTER N WITH DOT ABOVE -> SMALL
          when "\341\271\254"
            return "\341\271\255" # LATIN CAPITAL LETTER T WITH DOT BELOW -> SMALL
          when "\305\232"
            return "\305\233" # LATIN CAPITAL LETTER S WITH ACUTE -> SMALL
          when "\316\233"
            return "\316\273" # GREEK CAPITAL LETTER LAMDA -> SMALL
          when "\306\256"
            return "\312\210" # LATIN CAPITAL LETTER T WITH RETROFLEX HOOK -> SMALL
          when "\356\242\273"
            return "\?" # ?
          else
            return letter.to_s
          end
        else
          return letter.at(0).to_s
        end
      end
      
      def translate(options = {})
        I18n.translate(self, options)
      end
      alias :t :translate
      
      def translate_and_span(options = {})
        self.translate(options).span
      end
      alias :ts :translate_and_span

      def translate_and_encode(options = {})
        self.translate(options).to_xs
      end
      alias :te :translate_and_encode
      
      def capitalize_first_letter
        self.blank? ? self : self[0..0].upcase + self[1...self.size]
      end
    end
  end
end