---
title: cloudera使用常用命令笔记
date: 2019-06-22 19:58:29
tags: 大数据
categories: BigData
---

## cloudera使用常用命令笔记

<!--more-->

- 升级jdk,直接rm掉以前的jdk,修改`/etc/profile`,关闭服务后重启

  ```sh
  # 关闭服务
  service cloudera-scm-agent stop
  service cloudera-scm-server stop
  ```

  ```sh
  service hadoop-hdfs-datanode stop
  service hadoop-hdfs-journalnode stop
  service hadoop-hdfs-namenode stop
  service hadoop-hdfs-secondarynamenode stop
  service hadoop-httpfs stop
  service hadoop-mapreduce-historyserver stop
  service hadoop-yarn-nodemanager stop
  service hadoop-yarn-proxyserver stop
  service hadoop-yarn-resourcemanager stop
  service hbase-master stop
  service hbase-regionserver stop
  service hbase-rest stop
  service hbase-solr-indexer stop
  service hbase-thrift stop
  service hive-metastore stop
  service hive-server2 stop
  service impala-catalog stop
  service impala-server stop
  service impala-state-store stop
  service oozie stop
  service solr-server stop
  service spark-history-server stop
  service sqoop2-server stop
  service sqoop-metastore stop
  service zookeeper-server stop
  ```

  ```sh
  # 重启
  service cloudera-scm-agent start
  service cloudera-scm-server start
  # ps:重启后,需要等待一定时间,等待服务全部启动以后使用
  ```

  