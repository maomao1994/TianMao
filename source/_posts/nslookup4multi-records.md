---
title: nslookup4multi-records
date: 2018-10-21 19:21:03
tags: Linux
categories: Linux
---
## nslookup批量处理域名

<!--more-->

```sh
#!/usr/bin/env bash
echo "############# Reverse DNS ##############"
while read id servername;do
    ip=$(nslookup $servername | grep ^Name -A1 | grep Address | awk '{printf ($2" ")}');
    echo "$id,$servername,$ip";
done<$1 >$2
```
以上，$1是第一个参数，就是要打开的域名文件，$2是跟在命令后的第二个参数，是需要保存结果的文件。^Name -A1表示:找到以Name开头的行，-A1表示显示下一行，grep的具体使用如下：

```
使用方式：grep [OPTIONS] PATTERN [FILE...]
grep [OPTIONS] [-e PATTERN | -f FILE] [FILE...]
常用选项：
　--color=auto：对匹配到的文本着色后进行高亮显示；
　-i：忽略字符的大小写
　-o：仅显示匹配到的字符串
　-v：显示不能被模式匹配到的行
　-E：支持使用扩展的正则表达式
　-q：静默模式，即不输出任何信息
　-A #：显示被模式匹配的行及其后#行
　-B #：显示被模式匹配的行及其前#行
　-C #：显示被模式匹配的行及其前后各#行
```
