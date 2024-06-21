#!/bin/bash

script_name=$()
if [ $# -eq 0 ]; then
    echo "please input Aeolus dashboardId or sheetId after shell, like $(basename $0) 220173"
    exit 1
fi


# 设置起始目录和目标文件夹路径
source_dir="/mnt/c/wlz/project/aeolus-data-migration/tts-insights"
destination_dir="/mnt/c/wlz/project/go_script/sheet/query_transform/input/ttsinsight"
execution_dir="/mnt/c/wlz/project/go_script/sheet/query_transform"
output_dir="/mnt/c/wlz/project/go_script/sheet/query_transform/output/finalRequest"
TEMP_FILE=$(mktemp)
KEYWORD="CaptureDashBoardName "

# 若目标目录不存在，则创建它
# mkdir -p "$destination_dir"

# 获取用户的输入
# echo "Enter the Aeolus dashboardId or sheetId:"
# read search_string
search_string=$1
echo ${search_string}

# 转到源目录
cd "$source_dir" || exit
git pull

# 查找匹配文件并拷贝到目标文件夹
find . -type f -name "*${search_string}*"
find . -type f -name "*${search_string}*" -exec cp {} "$destination_dir" \;

echo "Files containing '$search_string' have been copied to '$destination_dir'"

cd "$execution_dir" || exit


go run transform.go meta.go ${search_string} | tee "$TEMP_FILE"

# 从临时文件中过滤包含关键词的行
output=$(grep "$KEYWORD" "$TEMP_FILE")

# 检查是否有输出
if [ -z "$output" ]; then
    echo "没有找到包含关键词的行。"
    exit 1
fi

# 将输出中的每一行关键词存储到一个数组中
keywords=()
while IFS= read -r line; do
    keywords+=("$line")
done <<< "$output"

# 在特定目录下搜索包含关键词的文件名
for keyword in "${keywords[@]}"; do
    tt=${keyword#*${KEYWORD}}
    echo "search keyword: '$tt'"
    find "$output_dir" -type f -name "*$tt*" -print0 | xargs -0 -n 1 basename
    TARGET_FILE=$(find "$output_dir" -type f -name "*$tt*" -print0 | xargs -0 -n 1 basename)
done

# 删除临时文件
rm "$TEMP_FILE"

# 检查目标目录是否存在
if [ ! -d "$output_dir" ]; then
    echo "目录不存在: $output_dir"
    exit 1
fi

# 跳转到目标目录 explorer.exe: command not found
cd "$output_dir"

# 在Windows文件资源管理器中打开该目录
explorer.exe .

echo "已打开目录: $output_dir"

# 检查是否找到符合条件的文件
if [ -z "$TARGET_FILE" ]; then
    echo "没有找到包含关键词的文件"
    exit 1
fi

# 将字符串变量转换为数组变量
IFS=$'\n' read -r -d '' -a files_array <<< "$TARGET_FILE"

for COPYFILE in "${files_array[@]}"; do
    echo "已找文件: $COPYFILE"
done

WINDIR="C:\wlz\project\go_script\sheet\query_transform\output\finalRequest"
# 遍历数组
for COPYFILE in "${files_array[@]}"; do
    echo "复制文件内容到剪切板, fileName: $COPYFILE"
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command "Get-Content -Raw -Encoding UTF8 '$WINDIR/$COPYFILE' | Set-Clipboard"
done

