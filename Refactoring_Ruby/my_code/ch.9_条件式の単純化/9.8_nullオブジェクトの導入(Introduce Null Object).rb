# コードの中でnil値のチェックが頻繁に行われている(plan = customer ? customer.plan : BillingPlan.basic)
  # 元のclassのサブクラスとして実装
  # 独立したnullクラスを実装

# なんか不動産の関係みたいなやつ
# この際、建物に紐づくcustomerの情報がない場合がありうるので、nilが頻繁に発生しうるので、nilチェックが頻繁に起こる

# 建物
class Site
  attr_reader :customer
end

class Customer
  attr_reader :name, :plan, :history
end

# 支払い履歴
class PaymentHistory
  # 滞納
  def weeks_delinquent_in_last_year
  end
end

# client
customer = site.customer
plan = customer ? customer.plan : BillingPlan.basic
customer_name = customer ? customer.name : "null"
weeks_delinquent = customer.nil ? 0 : customer.history.weeks_delinquent_in_last_year


⬇︎

# １：クラスを作る

class MissingCustomer
  def missing?
    true
  end
end

class Customer
  def missing?
    false
  end
end

# 2：moduleを作る

module Nullable
  def missing?
    true
  end
end

class Customer
  include Nullable
end

# 3：既存のfactoryメソッドでnull_objを作る

# MissingCustomerクラスを追加し、元のCustomerクラスのfactoryメソッド内で返す
# nil判定をしてるclientコードをmissing?に置き換える

# 建物
class Site
  def customer
    @customer || Customer.new_missing
  end
end

# nullオブジェクト
class MissingCustomer
  def missing?
    true
  end

  def name
    "null"
  end

end

class NullPaymentHistory
  def weeks_delinquent_in_last_year
    0
  end
end

class Customer
  attr_reader :name, :plan, :history

  def self.new_missing
    MissingCustomer.new
  end

  def history
    PaymentHistory.new_null
  end
  
end

# 支払い履歴
class PaymentHistory
  # 滞納
  def weeks_delinquent_in_last_year
  end
end

# client
customer = site.customer
customer_name = customer.name
weeks_delinquent = customer.history.weeks_delinquent_in_last_year : 0