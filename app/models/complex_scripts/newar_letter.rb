module ComplexScripts
  class NewarLetter
    include KmapsEngine::PassiveRecord
    
    attr_accessor :unicode, :latin
    
    create unicode: 'अ', latin: 'a'
    create unicode: 'आ', latin: 'ā'
    create unicode: 'इ', latin: 'i'
    create unicode: 'ई', latin: 'ī'
    create unicode: 'उ', latin: 'u'
    create unicode: 'ऊ', latin: 'ū'
    create unicode: 'ऐ', latin: 'ai'
    create unicode: 'औ', latin: 'au'
    create unicode: 'क', latin: 'ka'
    create unicode: 'ख', latin: 'kha'
    create unicode: 'ग', latin: 'ga'
    create unicode: 'घ', latin: 'gha'
    create unicode: 'च', latin: 'ca'
    create unicode: 'छ', latin: 'cha'
    create unicode: 'ज', latin: 'ja'
    create unicode: 'झ', latin: 'jha'
    create unicode: 'त', latin: 'ta'
    create unicode: 'थ', latin: 'tha'
    create unicode: 'द', latin: 'da'
    create unicode: 'ध', latin: 'dha'
    create unicode: 'न', latin: 'na'
    create unicode: 'प', latin: 'pa'
    create unicode: 'फ', latin: 'pha'
    create unicode: 'ब', latin: 'ba'
    create unicode: 'भ', latin: 'bha'
    create unicode: 'म', latin: 'ma'
    create unicode: 'य', latin: 'ya'
    create unicode: 'र', latin: 'ra'
    create unicode: 'ल', latin: 'la'
    create unicode: 'व', latin: 'va'
    create unicode: 'स', latin: 'sa'
    create unicode: 'ह', latin: 'ha'
  end
end