# 配列を用意
score = ARGV[0]
scores = score.split(',')
shots = []
# 数字に置き換え
scores.each do |s|
  shots << if s == 'X'
             10
           else
             s.to_i
           end
end
points = 0
count = 0
flag = false
(0..shots.size).each do |i|
  # flagの制御
  if flag
    flag = false
    next
  end
  # 10回目のフレームは全て加算
  if count == 9
    points += shots[i..shots.size].sum
    break
  end
  # ポイント計算
  if shots[i] == 10 # strike
    points += shots[i] + shots[i + 1] + shots[i + 2]
    flag = false
  elsif shots[i] + shots[i + 1] == 10 # spare
    points += shots[i] + shots[i + 1] + shots[i + 2]
    flag = true
  else
    points += shots[i] + shots[i + 1]
    flag = true
  end
  count += 1
end
puts points
