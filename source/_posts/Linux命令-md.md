---
title: Linux命令.md
date: 2018-08-25 15:46:40
tags: Linux
categories: Linux
keywords: Linux命令积累
copyright: false
---

### 文件相关


### 网络相关
- tcpdump抓包，指定网卡，指定端口，指定host,写到test.pcap
```
tcpdump -i ens7f0 port 10080 and host 192.168.126.3 -w test.pcap
```


### 性能相关
- 杀掉所有的python进程（如：使用了多进程）
```
ps -ef | grep python | grep -v grep | awk '{print $2}' | xargs kill -9 
```

- 
