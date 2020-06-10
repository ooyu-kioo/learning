# 定数メソッドのみのサブクラスがある場合、冗長なので親クラスに吸収してあげる

class Person
  # ...
end

class Female < Person
  def female?
    true
  end

  def code
    "F"
  end
end

class Male < Person
  def female?
    false
  end

  def code
    "M"
  end
end

# client
bob = Female.new

⬇︎
# 


class Person
  def initialize(female, code)
    @female = female
    @code = code
  end

  def self.create_female
    Person.new(true, "F")
  end
  def self.create_female
    Person.new(false, "M")
  end

  def female?
    female
  end
end

class Female < Person
  def female?
    true
  end

  def code
    "F"
  end
end

class Male < Person
  def female?
    true
  end

  def code
    "M"
  end
end

# client
bob = Person.create_female