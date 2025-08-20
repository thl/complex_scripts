require 'ffi-icu'
module ComplexScripts
  class NewCollator < ICU::Collation::Collator
    
    def initialize
      super('new-Deva')
    end
  end
end