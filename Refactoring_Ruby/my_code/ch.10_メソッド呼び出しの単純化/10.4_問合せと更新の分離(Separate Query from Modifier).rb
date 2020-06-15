# 「目に見える副作用」はできるだけ排除したい
  # => 関数は参照透過性であるのが理想
  # => 問合せ(値の返却)と更新(副作用)を分離する

# セキュリティを破ろうとしたブラックリスト登録済みの人の名前を返すとともに、警報を発する関数
# これを

# 参照関数
def check_security(people)
  found = found_miscreant(people)
  some_later_code(fond)
end

def found_miscreant(people)
  people.each do |person|
    if person == "Don"
      send_aleart
      return "Don"
    end
    if person == "John"
      send_aleart
      return "John"
    end
  end
end

⬇︎
# found_miscreantから問合せ処理のfound_personを抜き出し、更新のみにする
# => topレベルの関数で更新と問合せの関数を組み合わせる、privateレベルには混ざったものを置かない

# 参照関数
def check_security(people)
  found_miscreant(people)
  found = found_person(people)
  some_later_code(fond)
end

def send_alert_if_miscreant_in(people)
  send_aleart unless found_person(people).empty?
end

def found_person(people)
  people.each do |person|
    return "Don" if person == "Don"
    return "John" if person == "John"
  end
  return ""
end