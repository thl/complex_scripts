class ComplexScripts::TibetanLetter < PassiveRecord::Base

  schema :id => Integer, :unicode => String, :wylie => String
  # select id, term, root_letter_id, wylie, sort_order from definitions where level = 'head term' and sort_order >= 43564 and sort_order <= 49933 and root_letter_id <> 3 order by sort_order
  create :unicode => 'ཀ', :wylie => 'k', :id => 1 # 1 - 13785 errores
  create :unicode => 'ཁ', :wylie => 'kh', :id => 2 # 13786 - 23658
  create :unicode => 'ག', :wylie => 'g', :id => 3 # 23659 - 43563
  create :unicode => 'ང', :wylie => 'ng', :id => 4 # 43564 - 49933
  create :unicode => 'ཅ', :wylie => 'c', :id => 5  # 49934
  create :unicode => 'ཆ', :wylie => 'ch', :id => 6
  create :unicode => 'ཇ', :wylie => 'j', :id => 7
  create :unicode => 'ཉ', :wylie => 'ny', :id => 8
  create :unicode => 'ཏ', :wylie => 't', :id => 9
  create :unicode => 'ཐ', :wylie => 'th', :id => 10
  create :unicode => 'ད', :wylie => 'd', :id => 11
  create :unicode => 'ན', :wylie => 'n', :id => 12
  create :unicode => 'པ', :wylie => 'p', :id => 13
  create :unicode => 'ཕ', :wylie => 'ph', :id => 14
  create :unicode => 'བ', :wylie => 'b', :id => 15
  create :unicode => 'མ', :wylie => 'm', :id => 16
  create :unicode => 'ཙ', :wylie => 'ts', :id => 17
  create :unicode => 'ཚ', :wylie => 'tsh', :id => 18
  create :unicode => 'ཛ', :wylie => 'dz', :id => 19
  create :unicode => 'ཝ', :wylie => 'w', :id => 20
  create :unicode => 'ཞ', :wylie => 'zh', :id => 21
  create :unicode => 'ཟ', :wylie => 'z', :id => 22
  create :unicode => 'འ', :wylie => "\'", :id => 23
  create :unicode => 'ཡ', :wylie => 'y', :id => 24
  create :unicode => 'ར', :wylie => 'r', :id => 25
  create :unicode => 'ལ', :wylie => 'l', :id => 26
  create :unicode => 'ཤ', :wylie => 'sh', :id => 27
  create :unicode => 'ས', :wylie => 's', :id => 28
  create :unicode => 'ཧ', :wylie => 'h', :id => 29
  create :unicode => 'ཨ', :wylie => '', :id => 30
  
  def self.all
    ComplexScripts::TibetanLetter.find(:all).sort{|a, b| a.id <=> b.id}
  end
end

