---
title: capture android https
date: 2018-09-13 16:35:28
tags:
---
```python
#coding:utf-8
# 本脚本只能使用monkeyrunner来使用
# 解析包名aapt dump badging F:\QQyinle_439.apk
from com.android.monkeyrunner import MonkeyRunner,MonkeyDevice
device=MonkeyRunner.waitForConnection()
device.installPackage('F:\\QQ_374.apk')
MonkeyRunner.sleep(3.0)
runComponent = "com.tencent.qqmusic/.activity.AppStarterActivity"
device.startActivity(component=runComponent)

#点击回车键
device.press('KEYCODE_ENTER','DOWN_AND_UP')

#截图
result=device.takeSnapshot()
#保存到文件
result.writeToFile('./test.png','png')

#点击搜索框
device.touch(100,100,'DOWN_AND_UP')

#录制点击的过程，将录制的过程转换为文件保存
from com.android.monkeyrunner.recorder import MonkeyRecorder as recorder
recorder.start(device)

#加载保存的文件，自动运行软件
```
```python
#coding=utf-8
import sys
from com.android.monkeyrunner import MonkeyRunner as mr

CMD_MAP = {
    'TOUCH':lambda dev,arg:dev.touch(**arg),
    'DRAG': lambda dev,arg:dev.drag(**arg),
    'TYPE': lambda dev,arg:dev.type(**arg),
    'PRESS': lambda dev,arg:dev.press(**arg),
    'WAIT': lambda dev,arg:mr.sleep(**arg)
}

def process_file(f,device):
    for line in f:
        (cmd,rest)=line.split('|')
        try:
            rest = eval(rest)
        except:
            print('unable to parse options')
            continue
        if cmd not in CMD_MAP:
            print('unknown command: ' + cmd)
            continue
        CMD_MAP[cmd](device, rest)
def main():
    file = sys.argv[1]
    f = open(file,'r')
    device = mr.waitForConnection()
    process_file(f,device)
    f.close()

if __name__ == '__main__':
    main()
```