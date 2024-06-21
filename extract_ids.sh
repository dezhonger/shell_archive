#!/bin/bash

# 检查是否传入文件路径
if [ $# -eq 0 ]; then
    echo "用法: $0 <input_file>"
    exit 1
fi

# 输入文件路径
input_file="$1"

# 检查文件是否存在
if [ ! -f "$input_file" ]; then
    echo "文件不存在: $input_file"
    exit 1
fi

# 读取文件并解析每个URL
while IFS= read -r url; do
    # 提取dashboard/后的数字
    DASHBOARD_ID=$(echo "$url" | grep -oP '(?<=dashboard/)[0-9]+')

    # 提取sheetId=后的数字
    SHEET_ID=$(echo "$url" | grep -oP '(?<=sheetId=)[0-9]+')

    # 输出提取的数字，使用空格分隔
    echo "$DASHBOARD_ID $SHEET_ID"
done < "$input_file"