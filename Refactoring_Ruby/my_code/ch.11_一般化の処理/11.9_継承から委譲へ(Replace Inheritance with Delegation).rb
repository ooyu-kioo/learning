# PolicyがHash(Rubyのbase_class)を継承してるけど、こんなんいらんはず

class Policy < Hash
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def <<(rule)
    key = rule.attribute
    self[key] ||= []
    self[key] << rule
  end
  
  def apply(account)
    self.each do |attribute, rule|
      rule.each { |rule| rule.apply(account) }
    end
  end
end

class Rule
  attr_reader :attribute, :default_value

  def initialize(attribute, default_value)
    @attribute = attribute
    @default_value = default_value
  end

  def apply(account)
    # ...
  end
end

⬇︎
require "forwardable"

class Policy
  extend Forwardable
  # railsの場合ActiveSupport::delegate
  def_delegators :@rules, :size, :empty?, :[]
  attr_reader :name

  def initialize(name)
    @name = name
    @rules = {}
  end

  def <<(rule)
    key = rule.attribute
    @rules[key] ||= []
    @rules[key] << rule
  end
  
  def apply(account)
    @rules.each do |attribute, rule|
      rule.each { |rule| rule.apply(account) }
    end
  end
end

class Rule
  attr_reader :attribute, :default_value

  def initialize(attribute, default_value)
    @attribute = attribute
    @default_value = default_value
  end

  def apply(account)
    # ...
  end
end