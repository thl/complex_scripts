module LocaleSetup
  def set_locale
    language = session[:language]
    available_locales = I18n.available_locales
    language = language.to_sym if !language.nil?
    if language.nil? || !available_locales.include?(language)
      language = (request.env["HTTP_ACCEPT_LANGUAGE"] || "").scan(/[^,;]+/).collect {|l| l[0..1].to_sym}.find{|l| available_locales.include?(l)}
      language = I18n.default_locale if language.nil? || !available_locales.include?(language.to_sym) 
      session[:language] = language.to_s
    end
    I18n.locale = language
  end
end