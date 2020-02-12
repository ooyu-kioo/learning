### データではなく、振る舞いに依存する
- objectが持つもの
  - 振る舞い＝method
    - 単一責任のclassであれば、同じ振る舞いはただ一箇所に存在する
  - データ
    - データへのアクセス
      - インスタンス変数を直接参照
      - アクセサメソッドで隠蔽する

##### インスタンス変数の隠蔽
- データは、アクセサメソッドで隠蔽する
  - アクセサメソッドに入れ込むことで、ある変数はデータ(=どこからでも参照される,存在しうる)から振る舞い(ただ一箇所に存在する)になるため

##### データ構造の隠蔽

例えば以下のようなdiametersメソッド

```rb
class ObscuringReferences
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def diameters
  data.collect {|cell|10cell[0] + (cell[1] * 2)} # 0はリム、1はタイヤ
  end
  # ... インデックスで配列の値を参照するメソッドがほかにもたくさん
```

渡された配列データのindex指定で実行してる=配列の構造に依存している
=> データ構造が変更されるとしんどい
なんで、

```rb
class RevealingReferences
  attr_reader :wheels
  
  def initialize(data)
    @wheels = wheelify(data)
  end

  def diameters
    wheels.collect {|wheel| wheel.rim + (wheel.tire * 2
  end
  
  # ... これでだれでもwheelにrim/tireを送れる
  Wheel = Struct.new(:rim, :tire)
  def wheelify(data)
    data.collect {|cell| Wheel.new(cell[0], cell[1])}
  end
end
```
こうすることで、引数のデータ構造に依存する箇所を一箇所にできる
=> 複雑なデータ構造をclassが受け取ることを強いられる場合は、そのデータ構造の認識する振る舞いを外だししてやる

***

### あらゆる箇所を単一責任にする

##### methodから余計な責任を抽出
- methodに関してもclassと同じく、自身が負う責任を単一に保つ

例えば
```rb
def diameters
  wheels.collect { |wheel| diameter(wheel) }
end
# 1つの車輪の直径を計算する
def diameter(wheel)
  wheel.rim + (wheel.tire * 2)
end
```
- 単一責任のメソッドであることのメリット
  - classの役割が明確になる
  - 無駄なコメントが減る => method名がその処理を表す
  - 再利用性
