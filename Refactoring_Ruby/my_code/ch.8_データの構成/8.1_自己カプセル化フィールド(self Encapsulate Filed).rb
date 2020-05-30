=begin

フィールドアクセスの考え方
- 直接アクセス
- accessorを持ちいた間接アクセス
 - サブクラスがaccessorをoverrideして自由に変更できる
  - ex:superではそのまま使用してるけど、subでは計算後の値をfieldとしたい場合

=> 基本直接アクセスで、sub等で必要性がでたら間接アクセスに変える

=end

class Item
  def initialize(base_price, tax_rate)
    @base_price = base_price
    @tax_rate = tax_rate
  end

  def raise_base_price_by(percent)
    @base_price = @base_price * (1 + percent/100)
  end

  def total
    @base_price * (1 + @tax_rate)
  end
end

⬇︎
# Itemの挙動を変えることなく、サブクラスでimport_dutyを加味したtax_rateのsetができる


class Item
  attr_accessor :base_price, :tax_rate

  # setterがobj生成後のfield変更用として使われている = 初期化(単純な値の代入)とは異なる実装の場合、
  # initializeで直接アクセスによるfiledの初期化を行う
  def initialize(base_price, tax_rate)
    setup(base_price, tax_rate)
  end
  def setup(base_price, tax_rate)
    @base_price = base_price
    @tax_rate = tax_rate
  end

  def raise_base_price_by(percent)
    @base_price = @base_price * (1 + percent/100)
  end

  def total
    @base_price * (1 + @tax_rate)
  end
end


class ImportedItem < Item
  attr_reader :import_duty

  def initialize(base_price, tax_rate, import_duty)
    super(base_price, tax_rate)
    @import_duty = import_duty
  end

  def tax_rate
    super + import_duty
  end
end
