---
title: Linux命令.md
date: 2018-08-25 15:46:40
tags: Linux
categories: Linux
keywords: Linux命令积累
copyright: false
---

### 文件相关
<<<<<<< HEAD
- 建立软链接，快速启动软件（不用修改环境变量）
```sh
ss@ss:/usr/bin$ sudo ln -s /opt/pycharm/bin/pycharm.sh pycharm
```
=======
- 查看文件行数
```sh
wc -l filename #就是查看文件里有多少行,wc -l *.csv ==>列出所有csv文件行数
wc -w filename #看文件里有多少个word。
wc -L filename #文件里最长的那一行是多少个字
>>>>>>> 270e0d60ab98ec4577dea8a00c5377e2130b28b6
```

### 网络相关
- 连接远程服务器
```sh
ssh tm@172.16.18.24
# 之后会提醒输入密码
```

- 远程上传文件，下载文件命令

```sh
# 下载
scp -r username@192.168.0.1:/home/username/remotefile.txt
# 上传
scp -r localfile.txt username@192.168.0.1:/home/username/
```

- 开通ssh服务
```sh
# 查看是否开启了ssh服务是否安装,使用命令：
sudo ps -e |grep ssh
# 先更新资源列表，使用命令：
sudo apt-get update
# 安装openssh-server，使用命令：
sudo apt-get install openssh-server
# 启动ssh命令
service sshd start
# 停止ssh命令
service sshd stop
```


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
```sh
ps -ef | grep python | grep -v grep | awk '{print $2}' | xargs kill -9 
```
### 编辑相关
- 源码查看：主要使用vim快速查看函数的原型定义
```
#（1）真对于系统函数，偶尔可以使用shift+K进行定位
#（2）主要的方法是使用ctags工具来生成tags文件，方法如下
sudo apt-get install ctags # 安装ctags软件
ctags -R # 生成tags文件
:set tags=绝对路径（tags文件）
# 跳转方法：ctrl+]跳转到光标所在单词的tag，ctrl+T：跳回到原来的位置，有多个tag的时候使用g]键进行跳转。
```


### 编译相关
- 编译openssl相关的demo
```sh
# 编译服务端
gcc -o ssl_server ssl_server.c -Wall -g -lssl -lcrypto
# 编译客户端
gcc -o ssl_client ssl_client.c -Wall -g -lssl -lcrypto
```





- 
