# あるクラスがfieldとして抱えているデータをobjとして振る舞いと共に切り出す

# 注文している顧客を文字列として格納している
class Order
  attr_accessor :customer

  def initialize(customer)
    @customer = customer
  end
end

# client
private
def self.number_of_orders_for(orders, customer)
  orders.select { |order| order.customer == customer }.size
end

⬇︎
# customerクラスを作り、Orderクラスで生成する
# Customerは値obj = immutableでなければならないので、setterでは新たなinstanceを生成する

class Order
  def initialize(customer_name)
    @customer = Customer.new(customer_name)
  end

  # getter
  def customer_name
    @customer.name
  end
  # setter
  def customer=(customer_name)
    @customer = Customer.new(customer_name)
  end
end

class Customer
  attr_reader :name

  def initialize
    @name = name
  end
end

# client
private
def self.number_of_orders_for(orders, customer)
  orders.select { |order| order.customer == customer }.size
end