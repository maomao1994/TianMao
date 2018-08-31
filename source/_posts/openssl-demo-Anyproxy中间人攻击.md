---
title: openssl_demo+Anyproxy中间人攻击
date: 2018-08-31 12:12:50
tags: openssl
categories: https
keywords : https demo handshake
---
## 基于openssl的handshake分析及基于Anyproxy的中间人攻击
### server+client
首先需要建立客户端和服务端，openssl已经提供了s_server和s_client程序供用户使用。在开始ssl握手以及数据传输之前需要生成证书和私钥。整个过程如下：
```
# 生成证书
openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes
# 启动服务器，绑定端口52013
openssl s_server -accept 52013 -key server.pem -cert server.pem
# 开启服务器连接
openssl s_client -connect 172.16.18.24:52013

```
s_server
![](Img/openssl_demo_server)
s_client
![](Img/openssl_demo_client)
### wireshark分析握手过程

