---
title: how-to-use-pidfilter-wireshark
date: 2018-09-05 15:04:18
tags: wireshark 
categories: https
keywords :wireshark使用
---
## 如何使用pidfilter版本的wireshark抓包
### 过滤设置
- 地址、端口
- 协议
- 进程名（这个功能只能在pid filter版本下使用）

### 显式设置
通过设置显式方式进行分析。
- 显式的颜色


### 保存设置

### 使用命令行进行抓包
```
dumpcap.exe -i \Device\NPF_{845F9D1E-8F0B-4991-9F9A-C55D107A046B} -w d:\test.pcap -b filesize:50000
# dumpcap.exe在wrieshark的安装根目录就可以看到，其中：
# -i 表示指定捕获的网卡设备，这里指定的是网卡设备的标识，是一个字符串
# -w 表示保存的路径以及文件名，如果是分文件保存，则会自动命名
# -b filesize:N  表示指定每个文件的大小是NKB，如上50000表示 50000 KB，也就是50M
```
