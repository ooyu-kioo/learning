# 特定の引数が複数箇所でメソッドに渡される場合 => そいつらをデータの塊として、class化する(値obj)
# 元の引数を受け取るメソッドでは、引数に関する重複した処理を行うことも多いので、振る舞いも値objに移せる

class Account
  def add_charge(base_price, tax_rate, imported)
    total = base_price + baseprice * tax_rate
    total += base_price * 0.1 if imported
    @charge << total
  end

  def total_charge
    @charge.inject(0) { |total, charge| total + charge }
  end
end

# client
account.add_charge(5, 0.1, true)
account.add_charge(12, 0.125, false)
total = account.total_charge

⬇︎
# base_price, tax_rate, importedをまとめる

# 値obj
class Charge
  attr_accessor :base_price, :tax_rate, :imported

  def initialize(base_price, tax_rate, imported)
    @base_price = base_price
    @tax_rate = tax_rate
    @imported = imported
  end

  def total
    result = @base_price + @base_price * @tax_rate
    result += @base_price * 0.1 if @imported
    result
  end
end

class Account
  def add_charge(charge)
    @charge << total
  end

  def total_charge
    @charge.inject(0) do |total_for_amount, charge|
      total_for_amount + charge.total
    end
  end
end

# client
account.add_charge(Charge.new(5, 0.1, true))
account.add_charge(Charge.new(12, 0.125, false))
total = account.total_charge