# 家系図のモデリング
# 母親or 子を表すPersonクラス, 母親は複数の子を持てる

class Person
  attr_reader :mother, :children, :name
  
  def initialize(name, date_of_birth, date_of_death = nil, mother = nil)
    @name, @mother = name, mother
    @date_of_birth, @date_of_death = date_of_birth, date_of_death
    @children = []
    @mother.add_child(self) if @mother
  end

  def add_child(child)
    @children << child
  end

  # 再帰
  def number_of_living_descendants
    children.inject(0) do |count, child|
      count += 1 if child.alive?
      count += child.number_of_living_descendants
    end
  end

  # 再帰
  def number_of_descendants_named(name)
    children.inject(0) do |count, child|
      count += 1 if child.name == name
      count + child.number_of_descendants_named(name)
    end
  end
end

⬇︎ # 再帰関数の共通部分をまとめる

class Person
  # ...

  def number_of_living_descendants
    count_descendants_matching({|descendant| descendant.alive?})
    end
  end

  def number_of_descendants_named(name)
    count_descendants_matching({|descendant| descendant.name == name})
  end

  protected
  def count_descendants_matching(&block)
    children.inject(0) do |count, child|
      count += 1 if yield(child)
      count + child.count_descendants_matching(&block)
    end
  end
end

