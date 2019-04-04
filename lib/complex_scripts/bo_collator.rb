require 'ffi-icu'
module ComplexScripts
  class BoCollator < ICU::Collation::Collator
    
    def initialize(locale)
      super
    end
  end
end
