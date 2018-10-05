---
title: python http request
date: 2018-09-16 17:24:42
tags: http request
categories: python
---
```python
#!/usr/bin/env python
# -*-coding:utf-8 -*-
import os
import argparse
from getfilecode import get_file_code
from httpup import request_init,request_post
import shutil
from multiprocessing import Process,Pool
import threading


parser = argparse.ArgumentParser(description='########## upload records tool manual##########')
parser.add_argument('--maxrows', type=int, default = 10000,help="max rows/time")
parser.add_argument('--url', type=str, default = "",help="url address")
parser.add_argument('--username', type=str, default = "LiMing",help="username")
parser.add_argument('--password', type=str, default = "123456",help="password")
parser.add_argument('--path', type=str, default = "../data/ABNORMAL/MVFILE/",help="file path")
args = parser.parse_args()

maxrows = args.maxrows
url = args.url
path = args.path
username = args.username
password = args.password

# def main():
#     #count=0
#     foldernames = os.listdir(path)
#     # choose *.ok
#     for folder in foldernames:
#         filenames=os.listdir(path + folder)
#         # filter *.ok files
#         filenames=[filename for filename in filenames if filename[-3:]==".ok"]
#         for filename in filenames:
#             print("begin:%s"%filename)
#             status, index, topic = get_file_code(filename)
#             headers = request_init(topic, username, password)
#             file_ok=path + folder + "/" + filename
#             file_txt=path + folder + "/" + filename[:-3]
#             # record in one file has the same topic
#             request_post(url, headers, file_txt, maxrows)
#
#             # move resolved files to the folder
#             newPath="../data/ABNORMAL/RESOLVED/"
#             file_ok_new=newPath+filename
#             file_txt_new=newPath+ filename[:-3]
#             shutil.move(file_ok,file_ok_new)
#             shutil.move(file_txt,file_txt_new)
#             print("end:%s"%filename)
# if __name__ == '__main__':
#     while True:
#         main()


def run(folder):
    while True:
        filenames = os.listdir(path + folder)
        # filter *.ok files
        filenames = [filename for filename in filenames if filename[-3:] == ".ok"]
        for filename in filenames:
            print("begin:%s" % filename)
            status, index, topic = get_file_code(filename)
            headers = request_init(topic, username, password)
            file_ok = path + folder + "/" + filename
            file_txt = path + folder + "/" + filename[:-3]
            # record in one file has the same topic
            request_post(url, headers, file_txt, maxrows)

            # move resolved files to the folder
            newPath = "../data/ABNORMAL/RESOLVED/"
            file_ok_new = newPath + filename
            file_txt_new = newPath + filename[:-3]
            shutil.move(file_ok, file_ok_new)
            shutil.move(file_txt, file_txt_new)
            print("end:%s" % filename)

def main():

    threads=[]
    #count=0
    foldernames = os.listdir(path)
    # choose *.ok

    for folder in foldernames:
        t=threading.Thread(target=run,args=(folder,))
        print("start thread:%s"%folder)
        t.start()
        threads.append(t)
    for k in threads:
        k.join()

if __name__ == '__main__':
    main()
```
```python
# -*- coding:utf-8 -*-
AF_INT = ""
def get_file_code(filename):
    topic = ""
    status = 0
    index = -1

    if filename.find("V4")>-1:
        print("IPV4")
        if filename.find("C2R")>-1 or filename.find("R2C")>-1:
            topic="wa_dams_dnsc2r_dt"
            index = 0
            status= 1
            return status,index,topic
        if filename.find("R2A")>-1 or filename.find("A2R")>-1:
            topic="wa_dams_dnsr2a_dt"
            index = 1
            status = 2
            return status,index,topic
        if filename.find("C2F")>-1 or filename.find("F2C")>-1:
            topic = "wa_dams_dnsc2f_dt"
            index = 2
            status = 3
            return status,index,topic
        if filename.find("FIRST")>-1:
            topic = "wa_dams_dnsfirst_dt"
            index = 3
            status = 4
            return status,index,topic
        if filename.find("HJK")>-1:
            topic = "wa_dams_dns_hjk_dt"
            index = 4
            status = 5
            return status,index,topic
        if filename.find("TRAN")>-1:
            topic = "wa_dams_dns_tran_dt"
            index = 5
            status = 6
            return status,index,topic
        if filename.find("SP")>-1:
            topic = "wa_dams_dns_sp_dt"
            index = 6
            status = 7
            return status,index,topic
        if filename.find("DNAME")>-1:
            topic = "wa_dams_ab_dname_dt"
            index = 7
            status = 8
            return status,index,topic
        if filename.find("PKT")>-1:
            topic = "wa_dams_ab_pkt_error_dt"
            index = 8
            status = 9
            return status,index,topic
        if filename.find("IP")>-1:
            topic = "wa_dams_ab_answer_value_dt"
            index = 9
            status = 10
            return status,index,topic

    if filename.find("V6")>-1:
        print("IPV6")
        if filename.find("C2R")>-1 or filename.find("R2C")>-1:
            # WA_DAMS_DNSC2R_v6_DT
            topic = "wa_dams_dnsc2r_v6_dt"
            index = 10
            status = 11
            return status,index,topic
        if filename.find("R2A")>-1 or filename.find("A2R")>-1:
            # WA_DAMS_DNSR2A_V6_DT
            topic = "wa_dams_dnsr2a_v6_dt"
            index = 11
            status = 12
            return status,index,topic
        if filename.find("C2F")>-1 or filename.find("F2C")>-1:
            # WA_DAMS_DNSC2F_V6_DT
            topic = "wa_dams_dnsc2f_v6_dt"
            index = 12
            status = 13
            return status,index,topic
        if filename.find("HJK")>-1:
            # WA_DAMS_DNS_HJK_v6_DT
            topic = "wa_dams_dns_hjk_v6_dt"
            index = 14
            status = 15
            return status,index,topic
        if filename.find("TRAN")>-1:
            # WA_DAMS_DNS_TRAN_v6_DT
            topic = "wa_dams_dns_tran_v6_dt"
            index = 15
            status = 16
            return status, index, topic
        if filename.find("SP")>-1:
            # WA_DAMS_DNS_SP_v6_DT
            topic = "wa_dams_dns_sp_v6_dt"
            index = 16
            status = 17
            return status,index,topic
        if filename.find("DNAME")>-1:
            # WA_DAMS_AB_DNAME_v6_DT
            topic = "wa_dams_ab_dname_v6_dt"
            index = 17
            status = 18
            return status,index,topic
        if filename.find("PKT")>-1:
            # WA_DAMS_AB_PKT_ERROR_v6_DT
            topic = "wa_dams_ab_pkt_error_v6_dt"
            index = 18
            status = 19
            return status,index,topic
        if filename.find("IP")>-1:
            # WA_DAMS_AB_ANSWER_VALUE_v6_DT
            topic = "wa_dams_ab_answer_value_v6_dt"
            index = 19
            status = 20
            return status,index,topic

    return status, index, topic

```
```python
import requests
import time
def request_init(topic, username, password, format_="csv", rsplit="$", fsplit=","):
    headers = ["Connection: Keep-Alive",
               "User: %s" % username,
               "Password: %s" % password,
               "Format: %s" % format_,
               "Topic: %s" % topic,
               "Row-Split: %s" % rsplit,
               "Field-Split: %s" % fsplit
               ]
    return headers

def request_post(url,headers,file,maxrows):
    count = 0
    data = b''
    with open(file, 'rb')as f:
        start=time.time()
        for line in f:

            data += line
            count += 1
            if count > maxrows:

                try:
                    res = requests.post(url, data=data, headers=headers)
                except Exception:
                    pass
                end=time.time()
                print("time:%0.2f"%(end-start))
                #print(data.decode())
                count = 0
                data=b''

                # sleep 1000
        # records less than maxrows will be uploaded at last
        try:
            #print(data)
            res = requests.post(url, data=data, headers=headers)
        except Exception:
            print("request error 2")
```