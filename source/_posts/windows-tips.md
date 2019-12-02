---
![file_in_folder_bat](windows-tips/title: windows tips
date: 2018-09-13 19:42:06
tags:
---
## Windows系统使用

<!--more-->

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

###  使用windows开启wifi

- 开启虚拟网卡

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

- 设置共享网络



![file_in_folder_bat](windows-tips/windows-virtual-wifi-1.png)

![file_in_folder_bat](windows-tips/windows-virtual-wifi-2.png)