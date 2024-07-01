#!/bin/bash

# 检查jq是否安装
if ! command -v jq &> /dev/null
then
    echo "jq could not be found, please install it to proceed."
    exit 1
fi

# 定义变量
url="https://x.t.z/a/b/cc"
cookie="sso_session=ssssssssssssssssss"
data_raw='{
	"param": {
		"project_id": "",
		"parent_id": "",
		"name": ""
	}
}'

# 发送HTTP请求，将响应头和响应体一起保存到response
response=$(curl -s -i -X POST "$url" \
    -H "Content-Type: application/json" \
    -H "Cookie: $cookie" \
    --data-raw "$data_raw")

# 分离响应头和响应体
header=$(echo "$response" | sed -n '1,/^[[:space:]]*$/p')
body=$(echo "$response" | sed '1,/^[[:space:]]*$/d')

# 打印响应头
echo "响应头:"
#echo "$header"
echo "$header" | grep "X-Tt-Logid"

# Print the body if needed
echo "body:"
echo "$body"

# 解析JSON响应并提取特定值
result=$(echo "$body" | jq -r '.result')
message=$(echo "$body" | jq -r '.message')
code=$(echo "$body" | jq -r '.code')
node_id=$(echo "$body" | jq -r '.data.node_id')

# 输出提取的值
# echo "Result: $result"
# echo "Message: $message"
echo "node_id: $node_id"

# 处理错误情况
if [ "$code" != "0" ]; then
    echo "Request was not successful: $code"
    exit 1
fi
