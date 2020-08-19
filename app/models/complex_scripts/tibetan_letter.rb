module ComplexScripts
  class TibetanLetter
    include KmapsEngine::PassiveRecord
    
    attr_accessor :unicode, :wylie
    
    # select id, term, root_letter_id, wylie, sort_order from definitions where level = 'head term' and sort_order >= 43564 and sort_order <= 49933 and root_letter_id <> 3 order by sort_order
    create unicode: 'ཀ', wylie: 'k' # 1 - 13785 errores
    create unicode: 'ཁ', wylie: 'kh' # 13786 - 23658
    create unicode: 'ག', wylie: 'g' # 23659 - 43563
    create unicode: 'ང', wylie: 'ng' # 43564 - 49933
    create unicode: 'ཅ', wylie: 'c' # 49934
    create unicode: 'ཆ', wylie: 'ch'
    create unicode: 'ཇ', wylie: 'j'
    create unicode: 'ཉ', wylie: 'ny'
    create unicode: 'ཏ', wylie: 't'
    create unicode: 'ཐ', wylie: 'th'
    create unicode: 'ད', wylie: 'd'
    create unicode: 'ན', wylie: 'n'
    create unicode: 'པ', wylie: 'p'
    create unicode: 'ཕ', wylie: 'ph'
    create unicode: 'བ', wylie: 'b'
    create unicode: 'མ', wylie: 'm'
    create unicode: 'ཙ', wylie: 'ts'
    create unicode: 'ཚ', wylie: 'tsh'
    create unicode: 'ཛ', wylie: 'dz'
    create unicode: 'ཝ', wylie: 'w'
    create unicode: 'ཞ', wylie: 'zh'
    create unicode: 'ཟ', wylie: 'z'
    create unicode: 'འ', wylie: "\'"
    create unicode: 'ཡ', wylie: 'y'
    create unicode: 'ར', wylie: 'r'
    create unicode: 'ལ', wylie: 'l'
    create unicode: 'ཤ', wylie: 'sh'
    create unicode: 'ས', wylie: 's'
    create unicode: 'ཧ', wylie: 'h'
    create unicode: 'ཨ', wylie: ''
  end
end