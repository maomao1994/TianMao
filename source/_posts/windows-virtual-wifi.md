---
title: windows virtual wifi
date: 2018-09-13 16:20:11
tags: windows
categories: tips
---
```sh
# 运行下面的命令检查，显示“支持的承载网络：是（如果支持显示为：是）”；如果为“否”，则请略过本文。
netsh wlan show drivers
# 设置虚拟wifi的ID和密码，之后在网络适配器中将以太网的Adapter共享给新增加的虚拟Adapter
netsh wlan set hostednetwork mode=allow ssid=test_win key=12345678
# 开启虚拟wifi
netsh wlan start hostednetwork
# 关闭wifi
netsh wlan set hostednetwork mode=disallow

```
