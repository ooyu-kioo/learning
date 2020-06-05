# 片方のclassがもう片方を参照するだけだったが、互いに参照をかけたくなった場合

# 手法的には２つ
  # バックポインタ(今回はこっち)
  # リンクオブジェクト

# customerを参照するorderオブジェクト
# customerからorderへの参照も欲しくなった

class Order
  attr_accessor :customer
end

class Customer
  # ...
end

⬇︎
# orderのコレクションを保持するfieldをcustomerに追加する
# どっちがリンクを持つか
  # 参照obj：１ <=> 参照obj：多 => 多の方
  # 片方がもう片方のfiled_obj => 抱えてるほう
  # 参照obj：多 <=> 参照obj：多 => どっちでも

# この場合orderが持つ => orderへのアクセスメソッドをcustomerに追加
# orderのリンク更新メソッドで↑を使い２つのobjを同期する
class Order
  attr_reader :customer

  def customer=(value)
    customer.friend_orders.subtract(self) unless customer.nil?
    @customer = value
    customer.friend_orders.add(self) unless customer.nil?
  end

  # Orderが多のCustomerを持てる場合
  def add_customer(customer)
    customer.friend_orders.add(self)
    @customers.add(customer)
  end

  def remove_customer(customer)
    customer.friend_orders.subtract(self)
    @customers.subtract(customer)
  end
end

require "set" # 集合扱うclass
class Customer

  def initialize
    @orders = Set.new
  end
  # Orderがリンクを更新する際にのみ使われる
  def friend_orders
    @orders
  end

  def add_order(order)
    order.customer = self
  end

  # Orderが多のCustomerを持てる場合
  def add_order(order)
    order.add_customer(self)
  end

  def remove_order(order)
    order.remove_customer(self)
  end
end
