# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

# スペースの指定
SHORT_FORMAT_SPACE = 2
LONG_FORMAT_SPACE = 1
# 表示する列数の指定
COLUMN = 3

PERMISSIONS = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

FILE_TYPE = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

# オプションの設定
opt = OptionParser.new
params = {}
opt.on('-l') { |v| params[:l] = v }
opt.parse!(ARGV)

def rewrite_special_permissions(special, permissions)
  case special
  when 4
    permissions[0] = permissions[0][-1] == 'x' ? permissions[0].gsub(/.$/, 's') : permissions[0].gsub(/.$/, 'S')
  when 2
    permissions[1] = permissions[1][-1] == 'x' ? permissions[1].gsub(/.$/, 's') : permissions[1].gsub(/.$/, 'S')
  when 1
    permissions[2] = permissions[2][-1] == 'x' ? permissions[2].gsub(/.$/, 't') : permissions[2].gsub(/.$/, 'T')
  end
  permissions
end

# パーミッションを変換
def rewrite_permission(file_mode)
  special_permissions = file_mode.slice(-4).to_i

  file_permissions = file_mode.slice(-3..-1).split(//).map { |i| PERMISSIONS[i] }

  rewrite_special_permissions(special_permissions, file_permissions).join
end

# ファイルのstatusを取得
def get_file_statuses(file_names)
  file_names.map do |file_name|
    stat = File.stat(file_name)
    {
      type: FILE_TYPE[stat.ftype],
      permission: rewrite_permission(stat.mode.to_s(8)),
      hard_link: stat.nlink,
      uid: Etc.getpwuid(stat.uid).name,
      gid: Etc.getpwuid(stat.gid).name,
      size: stat.size,
      last_updated: stat.mtime.strftime('%b %d %H:%M'),
      name: file_name,
      blocks: stat.blocks / 2
    }
  end
end

# ファイル名、ファイル名のバイト数、ファイルに含まれる全角の文字数取得
def retrieve_file_names(file_names)
  file_names.map do |file_name|
    one_byte_char = file_name.scan(/[!-~]/).size
    tow_byte_char = file_name.scan(/[ぁ-んァ-ヶー\p{Han}]/).size
    total_byte = one_byte_char + tow_byte_char * 2
    { name: file_name, bytes: total_byte, tow_byte_char: }
  end
end

# インデントを揃えるためのbyte設定
def align_output_byte(file_statuses)
  hard_link_byte = 0
  uid_byte       = 0
  gid_byte       = 0
  size_byte      = 0
  blocks = []

  file_statuses.each do |hash|
    hard_link_byte = hash[:hard_link].to_s.length if hash[:hard_link].to_s.length > hard_link_byte
    uid_byte = hash[:uid].length if hash[:uid].length > uid_byte
    gid_byte = hash[:gid].length if hash[:gid].length > gid_byte
    size_byte = hash[:size].to_s.length if hash[:size].to_s.length > size_byte
    blocks.push(hash[:blocks])
  end

  { hard_link_byte:, uid_byte:, gid_byte:, size_byte:, blocks: }
end

# ロングフォーマットでファイル表示
def show_long_format(directory_file_names)
  file_statuses = get_file_statuses(directory_file_names)

  byte = align_output_byte(file_statuses)

  puts "total #{byte[:blocks].sum}"

  file_statuses.each do |hash|
    puts "#{hash[:type]}"\
         "#{hash[:permission]}"\
         "#{hash[:hard_link].to_s.rjust(byte[:hard_link_byte] + LONG_FORMAT_SPACE)}"\
         "#{hash[:uid].rjust(byte[:uid_byte] + LONG_FORMAT_SPACE)}"\
         "#{hash[:gid].rjust(byte[:gid_byte] + LONG_FORMAT_SPACE)}"\
         "#{hash[:size].to_s.rjust(byte[:size_byte] + LONG_FORMAT_SPACE)} "\
         "#{hash[:last_updated]} "\
         "#{hash[:name]}"
  end
end

# ショートフォーマットでファイル表示
def show_short_format(directory_file_names)
  file_names = retrieve_file_names(directory_file_names)

  max_bytes_hash = file_names.max_by { |file_name| file_name[:bytes] }

  split_file_names = file_names.each_slice((directory_file_names.size.to_f / COLUMN).ceil).to_a

  split_file_names[0].size.times do |i|
    COLUMN.times do |j|
      max_bytes = max_bytes_hash[:bytes]
      tow_byte_char = split_file_names[j][i][:tow_byte_char]
      print split_file_names[j][i][:name].ljust(max_bytes + SHORT_FORMAT_SPACE - tow_byte_char) unless split_file_names[j][i].nil?
    end
    print "\n"
  end
end

directory_file_names = Dir.glob('*').sort_by { |s| [s.downcase, s] }

params[:l] ? show_long_format(directory_file_names) : show_short_format(directory_file_names)
