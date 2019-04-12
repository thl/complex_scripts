require 'ffi-icu'
module ComplexScripts
  class BoCollator < ICU::Collation::Collator
    
    def initialize
      super('bo')
    end
  end
end
