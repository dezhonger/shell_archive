#!/bin/bash

# 检查jq是否安装
if ! command -v jq &> /dev/null
then
    echo "jq could not be found, please install it to proceed."
    exit 1
fi


# 检查是否提供文件路径
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <文件路径>"
    exit 1
fi

# 文件路径
file_path="$1"

# 检查文件是否存在
if [ ! -f "$file_path" ]; then
    echo "错误: 文件不存在: $file_path"
    exit 1
fi

# 定义请求参数
url="https://x.y.z"
header1="Content-Type: application/json"
header2="a: x"
header3="b: 1"

# 使用curl发送POST请求
response=$(curl -s -i -X POST "$url" \
    -H "$header1" \
    -H "$header2" \
    -H "$header3" \
    -d @"$file_path")

# 输出响应
# echo "响应:"
# echo $response

# 分离响应头和响应体
header=$(echo "$response" | sed -n '1,/^[[:space:]]*$/p')
body=$(echo "$response" | sed '1,/^[[:space:]]*$/d')

chartIds=$(echo "$body" | jq -r '.chartIds')
# echo "$header"
echo "$header" | grep -i "X-Tt-Logid"
echo "$body" | jq .
# echo "chartIds: $chartIds"
