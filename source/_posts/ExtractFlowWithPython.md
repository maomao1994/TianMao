---
title: ExtractFlowWithPython
date: 2020-03-06 10:51:48
tags: network
categories: python
---

使用Python+Scapy从pcap文件中提取流，输出pcap文件。

<!--more-->

```python
#!/usr/bin/env python
#encoding=utf-8
"""
@author: TianMao
@contact: tianmao1994@yahoo.com
@file: split-pcap.py
@time: 19-11-27 下午6:38
@desc:
    功能：按照TCP流切分pcap文件
    参考：https://github.com/mao-tool/packet-analysis
    环境：Scapy
    使用：python split-pcap.py test.pcap
    输出：test.pcap_220.194.64.35-443_192.168.137.22-56458_split.pcap
    问题：当前输出为splitcap文件的一般？疑似这里处理的是双向流？
"""

import sys
import re
import glob

# This is needed to suppress a really irrating warning message when scapy
# is imported
import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)



try:
    from scapy.all import*
except ImportError:
    print "scapy is not installed. See comments for installation suggestions"
    exit ()

# argument processing, require just the file name. If a second argument
# is provided make sure its an integer
if len (sys.argv) < 2 or len (sys.argv) > 3:
   print "Usage is: split-pcap.py file-name [packet-count]"
   print "Try\n     grep -A 20 Usage: " + sys.argv[0] +  \
                                            " | head -20\nfor details"
   exit ()

if len (sys.argv) == 3:
   inputFileString = sys.argv [1]
   try:
      inputTotalPackets = int (sys.argv [2])
   except ValueError:
      print "The second argument must be an integer <" + \
                       sys.argv [2] + "> does appear to be an integer"
      exit ()
else:
   inputFileString = sys.argv [1]
   inputTotalPackets = 0


# 保存文件夹
out_dir = "../../../../data/1/raw_2/"

# try opening the file.
try:
   pcapIn = PcapReader (inputFileString)
except IOError:
   print "It doesn't look like " + inputFileString + " exists"
   exit()
except NameError:
   print "It doesn't look like " + inputFileString + \
                                      " is a file that can be processed."
   print "Note that this script cannot process pcapng files. Review the "
   print "usage details for ideas on how to convert from pcapng to pcap"
   exit ()

# Extract out just the the file name. Note that I assume the the ".*/" match
# is greedy and will match until the last "/" character in the string. If
# the match fails there are no "/" characters so the whole string must be the
# name.
x = re.search ("^.*/(.*$)", inputFileString)
try:
   prefix = x.group(1) + "_"
except:
   prefix = inputFileString + "_"

# Look for prefix*_split.pcap files. If you find them print a
# warning and exit.

t = len (glob (prefix + "*_split.pcap"))
if t > 0:
   print "There are already " + str (t) + " files with the name " + \
       prefix + "*_split.pcap."
   print "Delete or rename them or change to a different directory to"
   print "avoid adding duplicate packets into the " + prefix + \
                                               "*_split.pcap trace files."
   exit ()

# 判断是否存在当前文件的文件夹
if not os.path.exists(out_dir + inputFileString):
    os.makedirs(out_dir + inputFileString)


pcapOutName = ""
oldPcapOutName = ""
packetCount = 0
donePercentage = 0;
oldDonePercentage = -1

# Loop for each packet in the file

for aPkt in pcapIn:

# count the packets read
   packetCount = packetCount + 1

# If the packet contains a TCP header extract out the IP addresses and
# port numbers
   if TCP in aPkt:
      ipSrc = aPkt[IP].src
      tcpSport = aPkt[TCP].sport
      ipDst = aPkt[IP].dst
      tcpDport = aPkt[TCP].dport

# put things in some sort of cannonical order. It doesn't really matter
# what the order is as long as packets going in either direction get the
# same order.
      if ipSrc > ipDst:
         pcapOutName = prefix + ipSrc + "-" + str(tcpSport) + "_" + ipDst + "-" + str(tcpDport) + "_split.pcap"
      elif ipSrc < ipDst:
         pcapOutName = prefix + ipDst + "-" + str(tcpDport) + "_" + ipSrc + "-" + str(tcpSport) + "_split.pcap"
      elif tcpSport > tcpDport:
         pcapOutName = prefix + ipSrc + "-" + str(tcpSport) + "_" + ipDst + "-" + str(tcpDport) + "_split.pcap"
      else:
         pcapOutName = prefix + ipDst + "-" + str(tcpDport) + "_" + ipSrc + "-" + str(tcpSport) + "_split.pcap"

# If the current packet should be written to a different file from the last
# packet, close the current output file and open the new file for append
# save the name of the newly opened file so we can compare it for the next
# packet.
      if pcapOutName != oldPcapOutName:
         if oldPcapOutName != "":
            pcapOut.close()

         if type(aPkt) == scapy.layers.l2.Ether:
            lkType = 1
         elif type (aPkt) == scapy.layers.l2.CookedLinux:
            lkType = 113
         else:
            print "Unknown link type: "
            type (aPkt)
            print "    -- exiting"
            exit

         # 修改文件路劲
         pcapOutName = out_dir+inputFileString+"/"+pcapOutName
         pcapOut = PcapWriter (pcapOutName, linktype=lkType, append=True)
         oldPcapOutName = pcapOutName

# write the packet
      pcapOut.write (aPkt)

# Write the progress information, either percentages if we had a packet-count
# argument or just the packet count.

      if inputTotalPackets > 0:
         donePercentage = packetCount * 100 / inputTotalPackets
         if donePercentage > oldDonePercentage:
            print "Percenage done: ", donePercentage
            oldDonePercentage = donePercentage
      else:
         print packetCount

```

