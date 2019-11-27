---
title: packet2flow
date: 2018-09-12 19:38:45
tags: packet flow
categories: https
---
## 包分析(packet to flow)

<!--more-->

### 工具安装
```sh
# ==========软件依赖=============
yum install libtool
yum install bzip2-devel
yum install flex
yum install byacc
yum install libpcap-devel
# =============end===============
# ===========软件安装=============
# 安装nfdump
(1)下载：https://github.com/phaag/nfdump
(2)安装：
chmod +x autogen.sh
./ autogen.sh
./configure
make
make install
# 安装nfcapd
(1)下载： https://github.com/YasuhiroABE/ansible-nfcapd
(2)安装：make install
# 安装Softflowd
(1)下载：https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/softflowd/softflowd-0.9.9.tar.gz
(2)安装：
./configure 
make 
make install
# ==============end==============
# ===========使用方法=============
# 步骤(1)
nfcapd -b localhost -p 12056 -l /home/train-week1-1/tmp
# 步骤(2)
softflowd -r /home/ train-week1-1/ train-week1-1.cap -n localhost:12056 -v 5
# 步骤(3)
nfdump -r nfcapd.201809120412 -o "fmt:%ts %te %sa %da %sp %dp %pr %flg %pkt %byt %tos" >train-week1-1-result.txt
```