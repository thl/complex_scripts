# require 'patches/i18n_patch'

I18n.load_path += Dir[ComplexScripts::Engine.root.join('config', 'locales', '**', '*.yml')]

LANGUAGES = {:en => {:locale => 'eng-US', :title => 'language.english'}, :ne => {:locale => 'nep-NP', :title => 'language.nepali', :unicode_range => [2304, 2431]}, :bo => {:title => 'language.tibetan', :locale => 'bod-CN', :unicode_range => [3840, 4095]}, :dz => {:locale => 'dzo-BT', :title => 'language.dzongkha'}, :zh => {:locale => 'zho-CN', :title => 'language.chinese'}}
unicode_ranges = Array.new
LANGUAGES.each do |key, value|
  range =  value[:unicode_range]
  unicode_ranges << [range[0], range[1], key] if !range.nil?
end
UNICODE_RANGES = unicode_ranges.freeze
