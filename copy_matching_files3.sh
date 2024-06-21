#!/bin/bash

# 检查参数数量
if [ $# -ne 3 ]; then
  echo "用法: $0 <搜索目录> <目标目录> <关键词文件>"
  exit 1
fi

# 参数
search_dir="$1"
target_dir="$2"
keywords_file="$3"

# 检查搜索目录是否存在
if [ ! -d "$search_dir" ]; then
  echo "错误: 搜索目录不存在!"
  exit 1
fi

# 检查目标目录是否存在，如果不存在则创建
if [ ! -f "$keywords_file" ]; then
  echo "错误: 关键词文件不存在!"
  exit 1
fi

# 检查目标目录是否存在，如果不存在则创建
if [ ! -d "$target_dir" ]; then
  mkdir -p "$target_dir"
fi

# 为避免重复拷贝的辅助数组
declare -A copied_files

# 读取关键词文件中的每个关键词
while IFS= read -r keyword; do
  # 查找匹配的文件并拷贝到目标目录
  find "$search_dir" -type f -name "*$keyword*" | while IFS= read -r file; do
    # 跳过已经拷贝的文件
    if [ -z "${copied_files["$file"]}" ]; then
      cp "$file" "$target_dir"
      copied_files["$file"]=1
    fi
  done
done < "$keywords_file"

echo "匹配的文件已拷贝到 $target_dir"