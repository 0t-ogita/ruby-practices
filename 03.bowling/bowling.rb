NUMBER_OF_PINS_STRIKE = 10
NUMBER_OF_PINS_SPARE = 10
FINAL_FRAME = 9

score = ARGV[0]
scores = score.split(',')
shots = scores.map do |s|
  if s == 'X'
    NUMBER_OF_PINS_STRIKE
  else
    s.to_i
  end
end
points = 0
number_of_frame = 0
second_pitch_skip = false
(0..shots.size).each do |i|
  # ストライクの時は2投目が無い為スキップ
  if second_pitch_skip
    second_pitch_skip = false
    next
  end
  # 10回目のフレームは全て加算
  if number_of_frame == FINAL_FRAME
    points += shots[i..shots.size].sum
    break
  end
  # ストライク、スペア、オープンフレームの3通りの計算方法を判断
  if shots[i] == NUMBER_OF_PINS_STRIKE
    # ストライク
    points += shots[i] + shots[i + 1] + shots[i + 2]
    second_pitch_skip = false
  elsif shots[i] + shots[i + 1] == NUMBER_OF_PINS_SPARE
    # スペア
    points += shots[i] + shots[i + 1] + shots[i + 2]
    second_pitch_skip = true
  else
    # オープンフレーム
    points += shots[i] + shots[i + 1]
    second_pitch_skip = true
  end
  number_of_frame += 1
end
puts points
