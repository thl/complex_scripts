module ComplexScriptsHelper
  include ComplexScripts::HelperMethods
  
  def language_option_links
    render(:partial => 'sessions/language_options')
  end
end