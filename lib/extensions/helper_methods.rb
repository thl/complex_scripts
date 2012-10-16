module ComplexScripts
  module HelperMethods
    def base_language_only
      yield if base_language?
    end

    def base_language?
      ComplexScripts.base_language?
    end

    def not_base_language
      yield unless ComplexScripts.base_language?
    end

    def not_base_language?
      !ComplexScripts.base_language?
    end

    def language_options(options = Hash.new)
      if not_base_language?
        language = I18n.locale
        options[:lang] = language
        options['xml:lang'] = language
        if options[:class].blank?
          options[:class] = language
        else
          options[:class] << " #{language}"
        end
      end
      return options
    end

    def language_options_string(options = Hash.new)
      return language_options(options).collect{|key, value| "#{key}=\"#{value}\""}.join(' ')
    end

    def globalized_submit_tag(name, options = Hash.new)
      options[:disable_with] = 'Processing...'
      submit_tag te(name), language_options(options)
    end

    # Receives a language code as argument and returns a hash with keys xml:lang and class set to that code. If no code is
    # given, it defaults to "bo" (tibetan). This can be used to easily pass it to form helpers to be styled accordingly.
    def fixed_language_options(options = Hash.new)
      if options[:lang].nil?
        options[:lang] = 'bo'
      else
        options[:lang] = options[:lang][0...2] if options[:lang].size>2
      end
      options['xml:lang'] = options[:lang]
      options[:class] = options[:lang]
      return options
    end

    # Not really related to complex scripts per se. Displays a title and attribute if attribute is not blank.
    def display_if_not_blank(name, attribute)
      if !attribute.blank?
        return "<p><b>#{name}:</b> #{attribute}</p>".html_safe
      else
        return nil
      end
    end

    def translate_and_span(key, options = {})
      translate(key, options).span.html_safe
    end
    alias :ts :translate_and_span

    def translate_and_encode(key, options = {})
      translate(key, options).to_xs.html_safe
    end
    alias :te :translate_and_encode    
  end
end
