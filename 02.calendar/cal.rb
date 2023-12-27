#!/usr/bin/env ruby

require 'date'
require 'optparse'

# オプションの設定
opt = OptionParser.new

params = {}

opt.on("-y year") {|v| params[:year] = v}
opt.on("-m month") {|v| params[:month] = v}

opt.parse!(ARGV)

# 本日の日付を取得
day = Date.today

# params 内にキーがある場合はキーの値、ない場合は今年 or 今月の値
year  = params[:year] || day.year
month = params[:month] || day.month

# 設定月１日を取得
first_day_of_month = Date.new(year.to_i, month.to_i, 1)

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

# number_of_days の日数だけ繰り返し
(first_day_of_month...first_day_of_next_month).each do |count_day|

  day_color =  count_day === day ? "\e[30m\e[47m" : "\e[37m\e[40m"

  print "#{day_color}#{count_day.mday.to_s.rjust(3)}"

  print "\n" if count_day.saturday?

end
