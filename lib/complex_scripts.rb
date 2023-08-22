require 'complex_scripts/engine'
require 'complex_scripts/bo_collator'
require 'unicode'
require 'extensions/string_ext'
require 'extensions/integer_ext'
require 'extensions/ext_hooks'
# require 'patches/xml_builder_patch'

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
