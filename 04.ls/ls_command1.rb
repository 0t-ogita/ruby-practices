#!/usr/bin/env ruby

# 表示する列数の指定
COLUMN = 3

# 列間のスペース数の指定
SPACE = 2

# ファイル名、ファイル名のバイト数、ファイルに含まれる全角の文字数取得
def retrieve_flie_names_string(flie_names)
  flie_names_string = flie_names.map do |flie_names|
    one_byte_char = flie_names.scan(/[!-~]/).size
    tow_byte_char = flie_names.scan(/[ぁ-んァ-ヶー\p{Han}]/).size
    total_byte = one_byte_char + tow_byte_char * 2
    {flie_name: flie_names, bytes: total_byte, tow_byte_char: tow_byte_char}
  end
  flie_names_string
end

# ファイルの表示
def show_flie_names(flie_names, column, max_bytes)
  flie_names[0].size.times do |i|
    column.times do |j|
      print flie_names[j][i][:flie_name].ljust(max_bytes - flie_names[j][i][:tow_byte_char]) if !flie_names[j][i].nil?
    end
    print "\n"
  end
end

# カレントディレクトリのファイル名を取得
flie_names = Dir.glob('*').sort_by { |s| [s.downcase, s] }

# ファイル名、ファイル名のバイト数、ファイルに含まれる全角の文字数取得
flie_names_string = retrieve_flie_names_string(flie_names)

# bytes が最大値の要素を取得
max_bytes_hash = flie_names_string.max_by { |file_info| file_info[:bytes] }

# 指定した配列数に分割
split_flie_names_string = flie_names_string.each_slice((flie_names.size.to_f / COLUMN).ceil).to_a

# ファイルの表示
show_flie_names(split_flie_names_string, COLUMN, max_bytes_hash[:bytes] + SPACE)
