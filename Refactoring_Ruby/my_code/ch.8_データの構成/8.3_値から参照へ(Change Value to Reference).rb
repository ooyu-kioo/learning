# 値objから参照objへ変更する
# 

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


⬇︎
# customerは値obj
# 同じ顧客からの注文はOrderが同じcustomerオブジェクトを共有するようにしたい

# Customerでfactoryメソッドを作り、

class Order
  def initialize(customer_name)
    @customer = Customer.with_name(customer_name)
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

  # レジストリobjの機能
  Instances = {}

  # factoryメソッド
  def self.with_name(name)
    Instances[name]
  end

  def self.load_customers
    new("Lemon Car Hire").store
    new("~").store
    new("~").store
  end

  def store
    Instances[name] = self
  end

end

# client
private
def self.number_of_orders_for(orders, customer)
  orders.select { |order| order.customer == customer }.size
end