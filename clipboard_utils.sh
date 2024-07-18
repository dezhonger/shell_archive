#!/bin/bash

# 函数: 将传入的参数值复制到剪切板
copy_value_to_clipboard() {
    local value="$1"
    
    # 创建临时文件并写入值
    local temp_file=$(mktemp)
    echo "$value" > "$temp_file"
    
    # 将 Linux 路径转换为 Windows 路径
    local win_temp_file=$(wslpath -w "$temp_file")
    
    # 使用 PowerShell 读取临时文件并将内容设置到剪切板
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command "Get-Content -Raw -Encoding UTF8 '$win_temp_file' | Set-Clipboard"
    
    # 删除临时文件
    rm "$temp_file"
}

# 函数: 将文件内容复制到剪切板 linux目录
copy_file_to_clipboard_wsl() {
    local file_path="$1"
    
    # 将 Linux 路径转换为 Windows 路径
    local win_file_path=$(wslpath -w "$file_path")
    
    # 使用 PowerShell 读取文件并将内容设置到剪切板
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command "Get-Content -Raw -Encoding UTF8 '$win_file_path' | Set-Clipboard"
}

#win目录
# 函数: 将文件内容复制到剪切板 linux目录
copy_file_to_clipboard_win() {
    local win_file_path="$1"
    
    # 使用 PowerShell 读取文件并将内容设置到剪切板
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command "Get-Content -Raw -Encoding UTF8 '$win_file_path' | Set-Clipboard"
}

# 示例代码测试函数调用（可以注释掉）
#copy_value_to_clipboard "Test value to clipboard!"
#copy_file_to_clipboard "/path/to/test_file.txt"
