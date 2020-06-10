# 条件分岐のリファクタ
  # タイプコードからポリモーフィズムへ => class自体を切り分けるので、分岐が元classの主要処理の場合
  # タイプコードからmoduleのextendへ => 条件分岐以外の振る舞いも多い場合
  # タイプコードからState/Strategyへ => 〃

  # タイプコードからState/Strategyへ => タイプコードが実行時に変更され、その変更内容が複雑でmoduleのextendでは手に負えないとき
  # ⬆︎いやつまりどんな場合？

  # 1つのアルゴリズムを単純化するならStrategy, 変化するobjならState

class MountainBike
  # type_codeによって色々処理分岐してる
  def initialize(params)
    set_state_from_hash(params)
  end
  def add_front_suspention(params)
    〜
  end
  def add_rear_suspention(params)
    〜
  end
  def off_road_ability
    〜
  end
  def price
    〜
  end

  private
  def set_state_from_hash(params)
    # hashのkeyに応じて色々とインスタンス変数をセットしてる
  end
end

⬇︎
# タイプコードごとにclass化する
# @bike_typeのインスタンス変数にタイプコードに応じたclassのinstanceを入れて、委譲する


class MountainBike
  extend Forwardable
  def_delegate :@bike_type, :off_road_ability

  attr_reader :type_code

  def initialize(params)
    set_state_from_hash(params)
  end

  def type_code=(value)
    @type_code = value
    @bike_type = case type_code
      when :rigid: RigidMountainBike.new(:tire_width => @tire_width)
      when :front_suspension: FrontSuspensionMountainBike.new
      when :full_suspension: FullSuspensionMountainBike.new
  end

  def add_front_suspention(params)
    〜
    # 必要に応じて@bike_typeを必要なclassに置き換える
  end
  def add_rear_suspention(params)
    〜
    # 必要に応じて@bike_typeを必要なclassに置き換える
  end
  def off_road_ability
    〜
  end
  def price
    〜
  end

  private
  def set_state_from_hash(params)
    # hashのkeyに応じて色々とインスタンス変数をセットしてる
  end
end

class RigidMountainBike
  def inisialize(params)
    @tire_width = params[:tire_width]
  end
  def off_road_ability
    〜
  end
end

class FrontSuspensionMountainBike
  # 上と同様
end

class FullSuspensionMountainBike
  # 上と同様
end