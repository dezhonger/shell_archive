#!/bin/bash

# 检查参数数量
if [ $# -ne 3 ]; then
  echo "用法: $0 <搜索目录> <搜索关键字> <目标目录>"
  exit 1
fi

# 参数
search_dir="$1"
search_keyword="$2"
target_dir="$3"

# 检查搜索目录是否存在
if [ ! -d "$search_dir" ]; then
  echo "错误: 搜索目录不存在!"
  exit 1
fi

# 检查目标目录是否存在，如果不存在则创建
if [ ! -d "$target_dir" ]; then
  mkdir -p "$target_dir"
fi

# 查找匹配的文件并拷贝到目标目录
find "$search_dir" -type f -name "*$search_keyword*" -exec cp {} "$target_dir" \;

echo "匹配的文件已拷贝到 $target_dir"