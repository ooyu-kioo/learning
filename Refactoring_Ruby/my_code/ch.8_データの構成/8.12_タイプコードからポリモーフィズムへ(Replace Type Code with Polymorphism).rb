
# 条件分岐のリファクタ
  # タイプコードからポリモーフィズムへ => class自体を切り分けるので、分岐が元classの主要処理の場合
  # タイプコードからmoduleのextendへ => 条件分岐以外の振る舞いも多い場合
  # タイプコードからState/Strategyへ => 〃

# インスタンスは :rigid=サスペンションなし、:front_suspension、full_suspensionのいずれかになる
# type_codeによって振る舞いが変わる
class MountrainBike
  def initialize(params)
    params.each { |key, value| instance_variable_set "@#{key}", value }
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR
    # type_codeによって値を変える
    if @type_code == :front_suspension || @type_code == :full_suspension
      result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
    end
    if @type_code == :full_suspension
      result += @rear_fork_travel * REAR_SUSPENTION_FACTOR
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
# client
bike = MountainBike.new(:type_code => :rigid, :tire_width => 2.5)
bike2 = MountainBike.new(:type_code => :front_suspension, :tire_width => 2, :front_fork_travel => 3)

⬇︎
# 個々のクラスにMountainBikeのtype_code分岐の振る舞いを移す
# 共有の振る舞いに関しては、MountainBikeをmoduke化して保持する

class RigidMountainBike
  include MountainBike

  def price
  end
  def off_road_ability
  end
end

class FrontSuspensionMountainBike
  include MountainBike

  def price
  end
  def off_road_ability
  end
end

class FullSuspensionMountainBike
  include MountainBike

  def price
  end
  def off_road_ability
  end
end

module MountainBike
  def wheel_circumference
    Math::PI(@wheel_diameter + @tire_diameter)
  end

end
# client
bike = FrontSuspensionBike.new(:tire_width => 2, :front_fork_travel => 3)
