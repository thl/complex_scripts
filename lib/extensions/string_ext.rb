module ComplexScripts
  module CoreExtensions # :nodoc:
    module String
      SPACE = ' '
      NB_SPACE = Unicode::U00A0
      SHAD = Unicode::U0F0D
      INTERSYLLABIC_TSHEG = Unicode::U0F0B
      DELIMITER_TSHEG = Unicode::U0F0C
      
      ZERO_WIDTH_NON_BREAK_SPACE = Unicode::UFEFF
      ZERO_WIDTH_SPACE = Unicode::U200B
      def bo_compare(b)
        @@bo_collator ||= BoCollator.new
        @@bo_collator.compare self, b.to_s
      end
      
      def new_compare(b)
        @@new_collator ||= ICU::Collation::Collator.new('und-Deva') # also possible "sa" for sanskrit and "ne" for nepali.
        @@new_collator.compare self, b.to_s
      end
      
      # Takes a string and spans characters in predefined unicode ranges with xml:lang and class attribute with
      # language code (ISO 369-3) for easy rendering. Also converts characters outside ascii range into NCR.
      def span
        return self if blank?
        return_string = ""
        i=0
        while i<self.size
          ch = self[i]
          ch_code = ch.ord
          if ch_code<=255
            return_string << ch
          else
            lang_code = ch_code.language_code
            if lang_code.nil?
              return_string << "&##{ch_code};"
            else
              return_string << "<span lang=\"#{lang_code}\" xml:lang=\"#{lang_code}\" class=\"#{lang_code}\">"
              while i<self.size && (ch_code = self[i].ord).language_code==lang_code
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
        return_string = ""
        i=0
        while i<self.size
          ch = self[i]
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
        word  = self.lstrip
        return nil if word.blank?
        case lang_code
        when 'jee', 'wme', 'san'
          letter = word[3]
          letter = letter.gsub(/-|=|_|\?|\/|\^|\342\211\241|\302\271|\302\262|\050/,'').lstrip.downcase # get rid of garbage that may precede head term
          return nil if letter.empty?
          return letter if letter.size==1
          if letter[1]=='h' && !"aeiou\304\201\305\253".include?(letter[0]) # last vowels are LATIN SMALL LETTER U WITH MACRON and LATIN SMALL LETTER A WITH MACRON
            letter = letter[1]
          else
            letter = letter[0]
          end
          #exceptions
          case letter[0]
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
            return letter
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
          return word[i] if i==0
          case word[i]
            when 'h'
              case word[i-1]
            when 'k', 'c', 't', 'p', 'z' then return word[i-1..i]
            when '+' then return word[i-2]
            when 's' then return i-2>=0 && word[i-2]=='t' ? 'tsh' : 'sh'
            else return 'h'
            end
          when 's' then return word[i-1]=='t' ? 'ts' : 's'
          when 'g' then return word[i-1]=='n' ? 'ng' : 'g'
          when 'z' then return word[i-1]=='d' ? 'dz' : 'z'
          end
          return word[i].html_safe
        else
          return word[0].html_safe
        end
      end
      
      def tibetan_base_letter
        pos = self.chars.find_index{|l| l.ord.subjoined_letter? }
        return self[pos].ord.root_of_subjoined_letter.unicode if !pos.nil?
        pos = self.chars.find_index{|l| l.ord.is_subfix? }
        pos.nil? || pos==0 ? nil : self[pos-1]
      end

      def prefixed_letters(lang_code = nil)
        zero_width_space = Unicode::UFEFF
        word  = self.lstrip.gsub(zero_width_space,'')
        return nil if word.blank?
        case lang_code
        when 'bod' # only works with wylie
          i = 0
          until word[i].ord.is_vowel?
            i+=1
            return nil if i>=word.size
          end
          prefix = word[0...i]
          if prefix==self.base_letter('bod')
            return i+1<word.size && word[i+1].ord.is_vowel? ? word[0..i+1].html_safe : word[0..i].html_safe
          else
            return (prefix+'a').html_safe
          end
          #return word[0..i].html_safe
        else
          return word[0].html_safe
        end
      end
      
      def is_tibetan_word?
        tibetan_letter_count = 0
        non_tibetan_letter_count = 0
        s = self.strip_tags.strip
        s.each_char do |c|
          if c.is_tibetan_letter?
            tibetan_letter_count += 1
          elsif !c.is_latin_punctuation? && !c.is_latin_digit?
            non_tibetan_letter_count += 1
          end
        end
        tibetan_letter_count > non_tibetan_letter_count
      end
      
      def is_devanagari_word?
        deva_letter_count = 0
        non_deva_letter_count = 0
        s = self.strip_tags.strip
        s.each_char do |c|
          if c.is_devanagari_letter?
            deva_letter_count += 1
          elsif !c.is_latin_punctuation? && !c.is_latin_digit?
            non_deva_letter_count += 1
          end
        end
        deva_letter_count > non_deva_letter_count
      end

      def is_tibetan_letter?
        self.ord.is_tibetan_letter?
      end

      def is_tibetan_digit?
        self.ord.is_tibetan_digit?
      end
      
      def is_devanagari_letter?
        self.ord.is_devanagari_letter?
      end
      
      def is_latin_punctuation?
        self.ord.is_latin_punctuation?
      end
      
      def is_latin_digit?
        self.ord.is_latin_digit?
      end
      
      def tibetan_cleanup
        term = self.strip
        term.gsub!(SPACE, NB_SPACE)
        term.gsub!(SHAD, '')
        term.slice!(0) if term.first == ZERO_WIDTH_NON_BREAK_SPACE
        last = term.last
        while last.ord.is_tibetan_punctuation? || last==SPACE || last==NB_SPACE
          term.chop!
          last = term.last
        end
        term
      end

      def syllable_counts
        syllable_positions.size
      end

      def translate(**options)
        I18n.translate(self, **options)
      end
      alias :t :translate

      def translate_and_span(**options)
        self.translate(**options).span
      end
      alias :ts :translate_and_span

      def translate_and_encode(**options)
        self.translate(**options).encode(:xml => :text).gsub(/[^\u0000-\u007F]/) {|c| "&##{c.ord};"}.html_safe
      end
      alias :te :translate_and_encode

      def capitalize_first_letter
        self.blank? ? self : self[0..0].upcase + self[1...self.size]
      end
      
      def strip_tags
        Hpricot.uxs(Rails::Html::FullSanitizer.new.sanitize(self, :tags=>[]))
      end
      
      def language_code
        spaces = [Unicode::UFEFF, Unicode::U00A0, ' ']
        s = self.strip_tags
        s.lstrip!
        while s.size>0 && spaces.include?(s.first)
          s.slice!(0)
        end
        ch = s.first
        ch.nil? ? nil : ch.ord.language_code
      end
      
      private

      def syllable_positions
        codes = self.codepoints
        positions = Array.new
        original_size = codes.size
        code = codes.shift
        while code
          code = codes.shift while code && !code.is_tibetan_letter?
          break unless code
          start_pos = original_size - codes.size - 1
          code = codes.shift while code && code.is_tibetan_letter?
          end_pos = original_size - codes.size - 2
          positions << [start_pos, end_pos]
        end
        positions
      end
    end
  end
end
