---
title: WebPagesWatch
date: 2019-03-01 14:00:05
tags: email notification
categories: python
---

为了及时获得复试通知的时间,使用python脚本自动间隔访问主页,检索关键字"复试",当找到关键字后立即邮件通知.这一小段代码包含两个方面的内容,一是网络请求,二是自动发送邮件(我使用的是yahoo的smtp服务器).全部代码如下:

<!--more-->

```python
#!/usr/bin/env python
#encoding=utf-8
"""
@author: TianMao
@contact: tianmao1994@yahoo.com
@file: lingyun.py
@time: 19-3-1 上午9:12
@desc:
"""
import smtplib
from email.mime.text import MIMEText
import requests
from bs4 import BeautifulSoup
import time

SMTP_SERVER = "smtp.mail.yahoo.com"
SMTP_PORT = 587
SMTP_USERNAME = "tianmao1994@yahoo.com"
SMTP_PASSWORD = "雅虎邮箱密码"
EMAIL_FROM = "tianmao1994@yahoo.com"
EMAIL_TO = "tianmao818@qq.com"
# EMAIL_TO = "1095474691@qq.com"
EMAIL_SUBJECT = """Notification:"""
co_msg = """Hello, 凌云!,华中科技大学\n"""


def sendMail(topic,content):
    msg = MIMEText(co_msg+content)
    msg['Subject'] = EMAIL_SUBJECT+topic
    msg['From'] = EMAIL_FROM
    msg['To'] = EMAIL_TO
    debuglevel = True
    mail = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
    mail.set_debuglevel(debuglevel)
    mail.starttls()
    mail.login(SMTP_USERNAME, SMTP_PASSWORD)
    mail.sendmail(EMAIL_FROM, EMAIL_TO, msg.as_string())
    mail.quit()

while True:
    try:
        print("---start---")
        url = "http://gszs.hust.edu.cn/zsxx/ggtz.htm"
        headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}
        response = requests.get(url, headers=headers)
        response.encoding = 'utf-8'
        soup = BeautifulSoup(response.text, "lxml")
        if (str(soup).find("复试")) == -1:
            print("---wait---")
            time.sleep(60)
            continue
        else:
            sendMail("""Huazhong University of Science and Technology""", "http://gszs.hust.edu.cn/zsxx/ggtz.htm")
            break
    except:
        continue
```
