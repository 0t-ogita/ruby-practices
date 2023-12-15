# 配列を用意
score = ARGV[0]
scores = score.split(',')
# 数字に置き換え
shots = scores.map do |s|
           if s == 'X'
             10
           else
             s.to_i
           end
          end
points = 0
number_of_frame = 0
second_pitch_skip = false
(0..shots.size).each do |i|
  # second_pitch_skipの制御
  if second_pitch_skip
    second_pitch_skip = false
    next
  end
  # 10回目のフレームは全て加算
  if number_of_frame == 9
    points += shots[i..shots.size].sum
    break
  end
  # ポイント計算
  if shots[i] == 10 # strike
    points += shots[i] + shots[i + 1] + shots[i + 2]
    second_pitch_skip = false
  elsif shots[i] + shots[i + 1] == 10 # spare
    points += shots[i] + shots[i + 1] + shots[i + 2]
    second_pitch_skip = true
  else
    points += shots[i] + shots[i + 1]
    second_pitch_skip = true
  end
  number_of_frame += 1
end
puts points
