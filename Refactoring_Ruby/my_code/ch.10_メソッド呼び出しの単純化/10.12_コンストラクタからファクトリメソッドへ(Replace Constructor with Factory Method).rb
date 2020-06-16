# よく使う場面 => 作成するobjの種類を条件分岐で分けている場合(複数箇所で)

class ProductController
  def create
    @product =
      if imported
        ImportedProduct.new(base_price)
      else
        if base_price > 1000
          LuxuryProduct.new(base_price)
        else
          Product.new(base_price)
        end
      end
  end
end

class Product
  def initialize(base_price)
    @base_price = base_price
  end

  def total_price
    @base_price
  end
end

class LaxuaryProduct < Product
  def total_price
    super + 0.1 * super
  end
end

class importedProduct < Product
  def total_price
    super + 0.25 * super
  end
end

⬇︎
# controllerでの分岐を複数箇所で行わないといけない場合辛み
# 責務として：Productの属性に関する処理をProduct内に押し込めれば、先々の変更がしやすくなる

class ProductController
  def create
    @product = Product.create(base_price, imported)
  end

end

class Product
  def initialize(base_price)
    @base_price = base_price
  end

  def self.create(base_price, imported=false)
    if imported
      ImportedProduct.new(base_price)
    else
      if base_price > 1000
        LuxuryProduct.new(base_price)
      else
        Product.new(base_price)
      end
    end
  end

  def total_price
    @base_price
  end
end

class LaxuaryProduct < Product
  def total_price
    super + 0.1 * super
  end
end

class importedProduct < Product
  def total_price
    super + 0.25 * super
  end
end