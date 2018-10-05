---
title: windows tips
date: 2018-09-13 19:42:06
tags:
---
## Windows系统使用
### 脚本相关
- 批量处理文件夹下指定类型的文件
```sh
@echo off
pushd I:\Research\data\Android\software
for /r %%c in (*.apk) do aapt dump badging %%c >%%c.txt
popd
```
结果如下：
![file_in_folder_bat](windows-tips/file_in_folder_bat.png)