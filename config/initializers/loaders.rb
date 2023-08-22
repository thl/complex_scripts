ActiveSupport.on_load(:action_controller) do
  require 'locale_setup'
  require 'extensions/helper_methods'
  include LocaleSetup
  include ComplexScripts::HelperMethods
  before_action :set_locale
end
ActiveSupport.on_load(:action_view) do
  require 'extensions/helper_methods'
  include ComplexScripts::HelperMethods
end