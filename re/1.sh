find "$directory" -type f \
    -exec grep -q -e 'cat' -e 'dog' {} \; \
    -exec sh -c 'grep -q "dog" "$1" && grep -q "cat" "$1" && echo "$1"' sh {} \;



或:
#!/bin/bash

# 检查是否提供了目录路径
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <目录路径>"
    exit 1
fi

# 获取目录路径
directory="$1"

# 使用 find 搜索每个文件并检查其中同时包含 `cat` 和 `dog`，输出文件名和行号
find "$directory" -type f -name "*.json" -exec sh -c '
    for file do
        if grep -q "cat" "$file" && grep -q "dog" "$file"; then
            grep -Hn -E "(cat|dog)" "$file"
        fi
    done
' sh {} +
