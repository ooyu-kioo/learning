# 結局書いてないわ
# 次から書く

class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDRENS = 2

  attr_reader :title
  attr_accessor :price_code

  def initialize(title, price_code)
    @title, @price_code = title, price_code
  end
end

class Rental
  attr_reader :movie, :days_rented
  
  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end
end

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(arg)
    @rentals << arg
  end

  def statement
    @rentals.each do |element|
    end
    # ~
    # => 処理は内容毎に関数に書き出す
    # => 一時変数も関数化できればやる
  end

  def amount_for(amount)
    this._amount = 0
      case amount.movie.price_code
      when Movie::REGULAR
        # ~
      when Movie::NEW_RELEASE
        # ~
      when Movie::CHILDRENS
        # ~
      end
  end

end