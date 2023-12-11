#!/usr/bin/env ruby

# 表示する列数の指定
number_of_columns = 3

# それぞれの列 ファイル名の最大文字数を取得
def get_max_string(number_of_columns, files_name)
  number_of_strings = []
  number_of_columns.times do |i|
    max_string = 0
    files_name.size.times do |j|
      next if files_name[i][j].nil?

      max_string = files_name[i][j].size if max_string < files_name[i][j].size
    end
    number_of_strings << max_string + 5
  end
  number_of_strings
end

# ファイルの表示
def show_files_name(files_name, number_of_columns, number_of_strings)
  files_name[0].size.times do |i|
    number_of_columns.times do |j|
      print files_name[j][i].ljust(number_of_strings[j]) if !files_name[j][i].nil?
    end
    print "\n"
  end
end

# カレントディレクトリのファイル名を取得
files = []
Dir.glob('*') do |item|
  files << item
end

# 大文字小文字区別なくソート
files = files.sort_by { |s| [s.downcase, s] }

# 指定した配列数に分割
files_name = files.each_slice((files.size.to_f / number_of_columns).ceil).to_a

# それぞれの列 ファイル名の最大文字数を取得
number_of_strings = get_max_string(number_of_columns, files_name)

# ファイルの表示
show_files_name(files_name, number_of_columns, number_of_strings)
