class Person
  attr_reader :mother, :children, :name

  def initialize(name, birth_date, death_date = nil, mother = nil)
    @name = name
    @birth_date = birth_date
    @death_date = death_date
    @mother = mother
    @children = []
    @mother.add_child(self) if @mother
  end

  def add_child(child)
    @children << child
  end


  def number_of_living_descendants
    count_descendants_matching { |descendant| descendant.alive?}
  end

  def number_of_descendants_named(name)
    count_descendants_matching { |descendant| descendant.name == name }
  end

  def alive?
    @death_date.nil?
  end

  def count_descendants_matching(&block)
    children.inject(0) do |count, child|
      count += 1 if yield child
      count + child.count_descendants_matching(&block)
    end
  end
end

a = Person.new("a", 1900, nil, nil)
b = Person.new("b", 1920, nil, a)
c = Person.new("c", 1920, nil, a)
d = Person.new("d", 1940, nil, b)
e = Person.new("e", 1940, 2000, b)
e2 = Person.new("e", 1940, nil, e)
p "a.number_of_living_descendants: #{a.number_of_living_descendants}"
p "a.number_of_living_descendants: #{a.number_of_descendants_named('e')}"
p "b.number_of_living_descendants: #{b.number_of_living_descendants}"
p "b.number_of_living_descendants: #{b.number_of_descendants_named('e')}"
