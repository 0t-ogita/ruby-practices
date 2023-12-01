#!/usr/bin/env ruby

require 'date'
require 'optparse'


# オプションの設定
opt = OptionParser.new

params = {}

opt.on('-y') {|v| params[:year] = v }
opt.on('-m') {|v| params[:month] = v }

opt.parse!(ARGV)

# 本日の日付を取得
day = Date.today

# optionの入力パターンで分岐
case
when params[:year] == nil && params[:month] == nil
    first_day_of_month = Date.new(day.year, day.month, 1)
when params[:year] == nil && params[:month] == true
    first_day_of_month = Date.new(day.year, ARGV[0].to_i, 1)
when params[:year] == true && params[:month] == true
    first_day_of_month = Date.new(ARGV[0].to_i, ARGV[1].to_i, 1)
end

# 翌月１日のを取得
first_day_of_next_month = first_day_of_month >> 1

# 今月の日数を取得
number_of_days = first_day_of_next_month - first_day_of_month

# 曜日の配列を用意
weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

# 今月１日の曜日番号取得
number_of_weekday = weekday.index(first_day_of_month.strftime('%a'))

# 年月・曜日を記載
puts "       #{first_day_of_month.month}月 #{first_day_of_month.year}"
puts " 日 月 火 水 木 金 土"

# 開始曜日だけ日付をずらす
number_of_weekday.times do |count|
    print "   "
end

# loop内で使用する日付を用意
count_day = first_day_of_month

# number_of_days の日数だけ繰り返し
number_of_days.to_i.times do

    if count_day === day
        print "\e[30m\e[47m#{count_day.mday.to_s.rjust(3)}"
    else
        print "\e[37m\e[40m#{count_day.mday.to_s.rjust(3)}"
    end

    print "\n" if count_day.strftime('%a') == "Sat"
    count_day += 1
    
end