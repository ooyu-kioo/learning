# 条件分岐のリファクタ
  # タイプコードからポリモーフィズムへ => class自体を切り分けるので、分岐が元classの主要処理の場合
  # タイプコードからmoduleのextendへ => 条件分岐以外の振る舞いも多い場合
  # タイプコードからState/Strategyへ => 〃

  # タイプコードからmoduleのextendへ => objにmoduleをミックスインすると、moduleの振る舞いを取り除くことが難しくなる
  #                                  ので、振る舞いを取り除く必要がない場合

# MountainBikeのobjにある段階でフロントサスペンションを追加したい

class MountainBike
  attr_writer :type_code

  def initialize(params)
    @type_code = params[:type_code]
    @commision = params[:commission]
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR
    if @type_code == :front_suspension || @type_code == :full_suspension
      〜
    end
    if @type_code == :full_suspension
      〜
    end
    result
  end

  def price
    case @type_code
    when :rigid
      〜
    when :front_suspension
      〜
    when :full_suspension
      〜
    end
  end
end

⬇︎
# 

class MountainBike
  attr_reader :type_code

  def initialize(params)
    @type_code = params[:type_code]
    @commision = params[:commission]
  end

  def type_code=(value)
    type_code = value
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR
    if type_code == :front_suspension || type_code == :full_suspension
      〜
    end
    if type_code == :full_suspension
      〜
    end
    result
  end

  def price
    case type_code
    when :rigid
      〜
    when :front_suspension
      〜
    when :full_suspension
      〜
    end
  end
end