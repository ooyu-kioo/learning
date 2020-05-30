# <=> 横流しブローカーの除去(Remove Middle Man)

# personとDepartment(部門)

# clientがpersonの上司を知ろうとする際、まず部門を知らなければならない
# その場合、managerの管理はDepartmentクラスが行っているという知識を
# clientが知っていなければならない
# そうなると、Person, Departmentの関係が変化した際にclientのコードにも変更が強いられる
class Person
  attr_accessor :department
end

class Department
  attr_reader :manager

  def initialize(manager)
    @manager = manager
  end
end

# client
john = Person.new()
manager = john.department.manager

⬇︎
# 委譲メソッドを作ってやる

class Person
  attr_accessor :department
  def manager
    @department.manager
  end
end

john = Person.new()
manager = john.manager
