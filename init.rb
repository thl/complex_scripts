# Include hook code here
require 'complex_scripts'
require 'locale_setup'
require 'extensions/string_ext'
require 'extensions/ext_hooks'
require 'patches/xml_builder_patch'
require 'patches/i18n_patch'
ActionView::Base.send :include, ComplexScriptsHelper
ActionController::Base.send :include, ComplexScriptsHelper
ActionController::Base.send :include, LocaleSetup
ActionController::Base.send :before_filter, :set_locale

# I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '**', '*.yml')]