#!/usr/bin/env ruby

require 'optparse'

# 表示する列数の指定
COLUMN = 3

# 列間のスペース数の指定
SPACE = 2

# オプションの設定
opt = OptionParser.new
params = {}
opt.on('-a') { |v| params[:a] = v }
opt.parse!(ARGV)

# ファイル名、ファイル名のバイト数、ファイルに含まれる全角の文字数取得
def retrieve_flie_names(flie_names)
  flie_names.map do |flie_name|
    one_byte_char = flie_name.scan(/[!-~]/).size
    tow_byte_char = flie_name.scan(/[ぁ-んァ-ヶー\p{Han}]/).size
    total_byte = one_byte_char + tow_byte_char * 2
    { name: flie_name, bytes: total_byte, tow_byte_char: }
  end
end

# ファイルの表示
def show_flie_names(flie_names, column, max_bytes)
  flie_names[0].size.times do |i|
    column.times do |j|
      print flie_names[j][i][:name].ljust(max_bytes - flie_names[j][i][:tow_byte_char]) if !flie_names[j][i].nil?
    end
    print "\n"
  end
end

directory_flie_names = if params[:a] == true
                         Dir.glob('*', File::FNM_DOTMATCH).sort_by { |s| [s.downcase, s] }
                       else
                         Dir.glob('*').sort_by { |s| [s.downcase, s] }
                       end

# ファイル名、ファイル名のバイト数、ファイルに含まれる全角の文字数取得
flie_names = retrieve_flie_names(directory_flie_names)

# bytes が最大値の要素を取得
max_bytes_hash = flie_names.max_by { |file_name| file_name[:bytes] }

# 指定した配列数に分割
split_flie_names = flie_names.each_slice((directory_flie_names.size.to_f / COLUMN).ceil).to_a

# ファイルの表示
show_flie_names(split_flie_names, COLUMN, max_bytes_hash[:bytes] + SPACE)
