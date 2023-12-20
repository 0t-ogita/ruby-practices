#!/usr/bin/env ruby

# 表示する列数の指定
COLUMN = 3

# 列間のスペース数の指定
SPACE = 2

# 全角文字の文字数が入っている配列の要素番号
TOW_BYTE_CHAR_ELEMENT = 1

# 全体の文字数(半角)、全角文字数を取得
def retrieve_flie_names_string(flie_names)
  flie_names_string = []
  flie_names.size.times do |i|
    one_byte_char = flie_names[i].scan(/[!-~]/).size
    tow_byte_char = flie_names[i].scan(/[ぁ-んァ-ヶー\p{Han}]/).size
    string = one_byte_char + tow_byte_char * 2
    flie_names_string << [string, tow_byte_char]
  end
  flie_names_string
end

# ファイルの表示
def show_flie_names(flie_names, string_element, column, max_string)
  flie_names[0].size.times do |i|
    column.times do |j|
      print flie_names[j][i].ljust(max_string - string_element[j][i][TOW_BYTE_CHAR_ELEMENT]) if !flie_names[j][i].nil?
    end
    print "\n"
  end
end

# カレントディレクトリのファイル名を取得
flie_names = Dir.glob('*').sort_by { |s| [s.downcase, s] }

# 全角文字、半角文字の文字数を取得
flie_names_string = retrieve_flie_names_string(flie_names)

# 指定した配列数に分割
split_flie_names = flie_names.each_slice((flie_names.size.to_f / COLUMN).ceil).to_a
split_string_element = flie_names_string.each_slice((flie_names_string.size.to_f / COLUMN).ceil).to_a

# 一次元化して最大値を取得
max_string = flie_names_string.flat_map(&:itself).max

# ファイルの表示
show_flie_names(split_flie_names, split_string_element, COLUMN, max_string + SPACE)
