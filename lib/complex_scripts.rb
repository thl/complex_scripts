require 'complex_scripts/engine'
require 'locale_setup'
require 'extensions/string_ext'
require 'extensions/fixnum_ext'
require 'extensions/ext_hooks'
require 'extensions/helper_methods'
require 'passive_record'

# require 'patches/xml_builder_patch'
# require 'patches/i18n_patch'

ActionView::Base.send :include, ComplexScripts::HelperMethods
ActionController::Base.send :include, ComplexScripts::HelperMethods

ActionController::Base.send :include, LocaleSetup
ActionController::Base.send :before_action, :set_locale

# I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
I18n.load_path += Dir[File.join(__dir__, '..', 'config', 'locales', '**', '*.yml')]

LANGUAGES = {:en => {:locale => 'eng-US', :title => 'language.english'}, :ne => {:locale => 'nep-NP', :title => 'language.nepali', :unicode_range => [2304, 2431]}, :bo => {:title => 'language.tibetan', :locale => 'bod-CN', :unicode_range => [3840, 4095]}, :dz => {:locale => 'dzo-BT', :title => 'language.dzongkha'}, :zh => {:locale => 'zho-CN', :title => 'language.chinese'}}
unicode_ranges = Array.new
LANGUAGES.each do |key, value|
  range =  value[:unicode_range]
  unicode_ranges << [range[0], range[1], key] if !range.nil?
end
UNICODE_RANGES = unicode_ranges.freeze

module ComplexScripts
  def ComplexScripts.character_within_unicode_range(ch)
    UNICODE_RANGES.each_with_index { |range, i| return i if ch>=range[0] && ch<=range[1] }
    return nil
  end
  
  def ComplexScripts.base_language?
    I18n.locale == I18n.default_locale
  end
  
  def ComplexScripts.update_model_translation(model, attribs, languages)
    model.all.each do |record|
      attribs.each do |attrib|
        value = record[attrib]
        values = Hash.new
        attrib_s = attrib.to_s
        languages.each{ |language| values[language] = record["#{attrib_s}_#{language.to_s}".to_sym] }
        languages.each do |language|
          model.locale = language
          record.send("#{attrib_s}=", values[language])
          record.save
        end
        model.locale = :en
        record.send("#{attrib_s}=", value)
        record.save
      end
    end    
  end
  
  def ComplexScripts.undo_model_translation(model, attribs, languages)
    model.all.each do |record|
      attribs.each do |attrib|
        languages.each do |language|
          model.locale = language
          record["#{attrib.to_s}_#{language.to_s}".to_sym] = record.send(attrib)
        end
        model.locale = :en
        record[attrib] = record.send(attrib)
      end
      record.save
    end    
  end
end