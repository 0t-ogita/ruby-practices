#!/usr/bin/env ruby

require 'date'
require 'optparse'

# オプションの設定
opt = OptionParser.new

params = {}

opt.on('-y') { |v| params[:year] = v }
opt.on('-m') { |v| params[:month] = v }

opt.parse!(ARGV)

# 本日の日付を取得
day = Date.today

# optionの入力パターンで分岐
case
when params[:year] == true && params[:month] == nil
  first_day_of_month = Date.new(ARGV[0].to_i, day.month, 1)
when params[:year] == nil && params[:month] == true
  first_day_of_month = Date.new(day.year, ARGV[0].to_i, 1)
when params[:year] == true && params[:month] == true
  first_day_of_month = Date.new(ARGV[0].to_i, ARGV[1].to_i, 1)
else
  first_day_of_month = Date.new(day.year, day.month, 1)
end

# 翌月１日のを取得
first_day_of_next_month = first_day_of_month >> 1

# 今月の日数を取得
number_of_days = first_day_of_next_month - first_day_of_month

# 年月・曜日を記載
puts "       #{first_day_of_month.month}月 #{first_day_of_month.year}"
puts " 日 月 火 水 木 金 土"

# 開始曜日だけ日付をずらす
first_day_of_month.wday.times do
  print "   "
end

# loop内で使用する日付を用意
count_day = first_day_of_month

# number_of_days の日数だけ繰り返し
number_of_days.to_i.times do

  if count_day === day
    char_color = "30"
    background_color = "47"
  else
    char_color = "37"
    background_color = "40"
  end

  print "\e[#{char_color}m\e[#{background_color}m#{count_day.mday.to_s.rjust(3)}"

  print "\n" if count_day.saturday?
  count_day += 1

end
