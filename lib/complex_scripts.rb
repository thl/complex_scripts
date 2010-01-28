# ComplexScripts
LANGUAGES = {:en => {:locale => 'eng-US', :title => :english}, :ne => {:locale => 'nep-NP', :title => :nepali, :unicode_range => [2304, 2431]}, :bo => {:title => :tibetan, :locale => 'bod-CN', :unicode_range => [3840, 4095]}, :dz => {:locale => 'dzo-BT', :title => :dzongkha}}
UNICODE_RANGES = Array.new
LANGUAGES.each do |key, value|
  range =  value[:unicode_range]
  UNICODE_RANGES << [range[0], range[1], key] if !range.nil?
end
UNICODE_RANGES = UNICODE_RANGES.freeze

module ComplexScripts
  def ComplexScripts.character_within_unicode_range(ch)
    UNICODE_RANGES.each_with_index { |range, i| return i if ch>=range[0] && ch<=range[1] }
    return nil
  end
  
  def ComplexScripts.base_language?
    I18n.locale == I18n.default_locale
  end
  
  def ComplexScripts.update_model_translation(model, attribs, languages)
    model.find(:all).each do |record|
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
    model.find(:all).each do |record|
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