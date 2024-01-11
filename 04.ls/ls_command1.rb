#!/usr/bin/env ruby

require 'optparse'

# 表示する列数の指定
COLUMN = 3

# 列間のスペース数の指定
SPACE = 2

# オプションの設定
opt = OptionParser.new
params = {}
opt.on('-r') { |v| params[:r] = v }
opt.parse!(ARGV)

# ファイル名、ファイル名のバイト数、ファイルに含まれる全角の文字数取得
def retrieve_file_names(file_names)
  file_names.map do |file_name|
    one_byte_char = file_name.scan(/[!-~]/).size
    tow_byte_char = file_name.scan(/[ぁ-んァ-ヶー\p{Han}]/).size
    total_byte = one_byte_char + tow_byte_char * 2
    { name: file_name, bytes: total_byte, tow_byte_char: }
  end
end

# ファイルの表示
def show_file_names(file_names, column, max_bytes)
  file_names[0].size.times do |i|
    column.times do |j|
      print file_names[j][i][:name].ljust(max_bytes - file_names[j][i][:tow_byte_char]) if !file_names[j][i].nil?
    end
    print "\n"
  end
end

directory_file_names = Dir.glob('*').sort_by { |s| [s.downcase, s] }

directory_file_names = directory_file_names.reverse if params[:r]

# ファイル名、ファイル名のバイト数、ファイルに含まれる全角の文字数取得
file_names = retrieve_file_names(directory_file_names)

# bytes が最大値の要素を取得
max_bytes_hash = file_names.max_by { |file_name| file_name[:bytes] }

# 指定した配列数に分割
split_file_names = file_names.each_slice((directory_file_names.size.to_f / COLUMN).ceil).to_a

# ファイルの表示
show_file_names(split_file_names, COLUMN, max_bytes_hash[:bytes] + SPACE)
