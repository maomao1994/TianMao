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

- Ubuntu <a href="https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/">镜像使用帮助</a>
```
# Ubuntu 的软件源配置文件是 /etc/apt/sources.list。将系统自带的该文件做个备份，将该文件替换为下面内容，即可使用 TUNA 的软件源镜像。
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse

```

### 性能相关
- 杀掉所有的python进程（如：使用了多进程）
```
ps -ef | grep python | grep -v grep | awk '{print $2}' | xargs kill -9 
```
### 编译相关
- 编译openssl相关的demo
```
# 编译服务端
gcc -o ssl_server ssl_server.c -Wall -g -lssl -lcrypto
# 编译客户端
gcc -o ssl_client ssl_client.c -Wall -g -lssl -lcrypto
```





- 
