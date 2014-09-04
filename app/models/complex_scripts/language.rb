# == Schema Information
# Schema version: 20090626173648
#
# Table name: languages
#
#  id                      :integer(4)      not null, primary key
#  title                   :string(100)     not null
#  code                    :string(3)       default(""), not null
#  locale                  :string(6)       default(""), not null
#  use_for_interface       :boolean(1)      not null
#  unicode_codepoint_start :integer(4)
#  unicode_codepoint_end   :integer(4)
#

module ComplexScripts
  class Language < ActiveRecord::Base
    validates_presence_of :title
    has_many :captions, :dependent => :nullify
    has_many :descriptions, :dependent => :nullify
    has_many :words, :dependent => :destroy

    def self.accepted_language_codes_array
      if columns_hash['use_for_interface'].nil?
        languages = Language.all
      else
        languages = Language.where(:use_for_interface => true)
      end
      languages.collect {|l| l.code[0..1]}.freeze
    end

    # {'en' => {:locale => 'eng-US', :title => 'English', :unicode_range => [0, 255]}}
    def self.languages_hash
      languages_hash = Hash.new
      for language in Language.all
        language_hash = {:locale => language.locale, :title => language.title}
        language_hash[:unicode_range] = [language.unicode_codepoint_start, language.unicode_codepoint_end] if !language[:unicode_codepoint_start].nil? && !language[:unicode_codepoint_end].nil?
        languages_hash[language.code[0..1]] = language_hash
      end
      languages_hash.freeze    
    end

    def label
      self.code.blank? ? self.title : self.code
    end

    def letters
      Letter.find_by_sql(['SELECT DISTINCT letters.* FROM letters, words WHERE words.letter_id = letters.id AND words.language_id = ? ORDER BY letters.`order`', id])
    end

    def self.find_iso_code(language)
      Language.where(['LEFT(code, 2) = ?', language.to_s]).first
    end
  end
end