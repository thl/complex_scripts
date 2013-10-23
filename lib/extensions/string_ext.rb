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
        return_string.html_safe
      end      
      alias :s :span
      
      # converts chars outside ascii range to NCR, but does not span. To be used in forms (buttons, drop-down
      # lists, etc.).
      def e # encode
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
        return_string.html_safe
      end      
      #alias :e :encode
      
      def base_letter(lang_code = nil)
        word  = self.lstrip.mb_chars
        return nil if word.blank?
        case lang_code
        when 'jee', 'wme', 'san'
          letter = word.to(3)
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
        when 'bod' # only works with wylie
          word = word.downcase
          i = 0
          until word[i].ord.is_vowel?
            i+=1
            return nil if i>=word.size
          end
          return '' if i==0
          i-=1
        	i-=1 if word[i]=='-'
        	i-=1 if (i>0 && word[i]=='w')
        	# check to see if it is a subscript (y, r, l, w)
        	if i>0
        	  case word[i]
        	    when 'r', 'l' then i-=1
        	    when 'y'
        	      case word[i-1]
      	        when '.' then return 'y'
              when 'n' then return 'ny'
                else i-=1
      	        end
      	      end
          end
          i-=1 if word[i]=='+'
          return word[i].to_s if i==0
          case word[i]
            when 'h'
              case word[i-1]
            when 'k', 'c', 't', 'p', 'z' then return word[i-1..i].to_s
            when '+' then return word[i-2].to_s
            when 's' then return i-2>=0 && word[i-2]=='t' ? 'tsh' : 'sh'
            else return 'h'
            end
          when 's' then return word[i-1]=='t' ? 'ts' : 's'
          when 'g' then return word[i-1]=='n' ? 'ng' : 'g'
          when 'z' then return word[i-1]=='d' ? 'dz' : 'z'
          end
          return word[i].to_s.html_safe
        else
          return word[0].to_s.html_safe
        end
      end

      def is_tibetan_letter?
        self.mb_chars.ord.is_tibetan_letter?
      end

      def is_tibetan_digit?
        self.mb_chars.ord.is_tibetan_digit?
      end

      def syllable_counts
        syllable_positions.size
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
        self.translate(options).to_xs.html_safe
      end
      alias :te :translate_and_encode

      def capitalize_first_letter
        self.blank? ? self : self[0..0].upcase + self[1...self.size]
      end
      
      def strip_tags
        Hpricot.uxs(HTML::FullSanitizer.new.sanitize(self, :tags=>[]))
      end
      
      private

      def syllable_positions
        codes = self.mb_chars.unpack("U*")
        positions = Array.new
        original_size = codes.size
        code = codes.shift
        while code
          code = codes.shift while code && !code.is_tibetan_alphanumeric?
          break unless code
          start_pos = original_size - codes.size - 1
          code = codes.shift while code && code.is_tibetan_alphanumeric?
          end_pos = original_size - codes.size - 2
          positions << [start_pos, end_pos]
        end
        positions
      end
    end
  end
end