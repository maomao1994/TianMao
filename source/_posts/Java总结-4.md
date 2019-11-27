---
title: Java总结-4
date: 2019-11-20 15:20:53
tags: Java
categories: Java
---

Java总结-4

<!--more-->

## 八、Redis高并发

### 1.Redis的高并发和快速原因？

> （1）Redis是基于内存的，内存的读写速度非常快；
>
> （2）Redis是单线程的，省去了很多上下文切换线程的时间；
>
> （3）Redis使用多路复用技术，可以处理并发的连接。非阻塞IO 内部实现采用epoll，采用了epoll+自己实现的简单的事件框架。epoll中的读、写、关闭、连接都转化成了事件，然后利用epoll的多路复用特性，绝不在io上浪费一点时间。

### 2.为什么Redis是单线程的？

> （1）官方答案
>
> 因为Redis是基于内存的操作，CPU不是Redis的瓶颈，Redis的瓶颈最有可能是机器内存的大小或者网络带宽。既然单线程容易实现，而且CPU不会成为瓶颈，那就顺理成章地采用单线程的方案了。
>
> （2）性能指标
>
> 关于redis的性能，官方网站也有，普通笔记本轻松处理每秒几十万的请求。
>
> （3）详细原因
>
> - 不需要各种锁的性能消耗
>
> > Redis的数据结构并不全是简单的Key-Value，还有list，hash等复杂的结构，这些结构有可能会进行很细粒度的操作，比如在很长的列表后面添加一个元素，在hash当中添加或者删除一个对象。这些操作可能就需要加非常多的锁，导致的结果是同步开销大大增加。总之，在单线程的情况下，就不用去考虑各种锁的问题，不存在加锁释放锁操作，没有因为可能出现死锁而导致的性能消耗。
>
> - 单线程多进程集群方案
>
> > 单线程的威力实际上非常强大，每核心效率也非常高，多线程自然是可以比单线程有更高的性能上限，但是在今天的计算环境中，即使是单机多线程的上限也往往不能满足需要了，需要进一步摸索的是多服务器集群化的方案，这些方案中多线程的技术照样是用不上的。所以单线程、多进程的集群不失为一个时髦的解决方案。
>
> - CPU消耗
>
> > 采用单线程，避免了不必要的上下文切换和竞争条件，也不存在多进程或者多线程导致的切换而消耗 CPU。

### 3.Redis支持的数据结构？

> (1)String：String数据结构是简单的key-value类型，value其实不仅可以是String，也可以是数字。 
>
> (2)List：list 就是链表，Redis list 的应用场景非常多，也是Redis最重要的数据结构之一，比如微博的关注列表，粉丝列表，消息列表等功能都可以用Redis的 list 结构来实现。
>
> (3)hash：hash 是一个 string 类型的 field 和 value 的映射表，hash 特别适合用于存储对象，后续操作的时候，你可以直接仅仅修改这个对象中的某个字段的值。
>
> (4)Set：set 对外提供的功能与list类似是一个列表的功能，特殊之处在于 set 是可以自动排重的。
>
> (5)ZSet：和set相比，sorted set增加了一个权重参数score，使得集合中的元素能够按score进行有序排列。

### 4.redis 提供 6种数据淘汰策略？

| 编号 | 名称            | 解释                                                         |
| :--- | :-------------- | :----------------------------------------------------------- |
| 1    | volatile-lru    | 从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰 |
| 2    | volatile-ttl    | 从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰 |
| 3    | volatile-random | 从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰 |
| 4    | allkeys-lru     | 当内存不足以容纳新写入数据时，在键空间中，移除最近最少使用的key（这个是最常用的） |
| 5    | allkeys-random  | 从数据集（server.db[i].dict）中任意选择数据淘汰              |
| 6    | no-eviction     | 禁止驱逐数据，也就是说当内存不足以容纳新写入数据时，新写入操作会报错。这个应该没人使用吧！ |
| 7    | volatile-lfu    | 从已设置过期时间的数据集(server.db[i].expires)中挑选最不经常使用的数据淘汰 |
| 8    | allkeys-lfu     | 当内存不足以容纳新写入数据时，在键空间中，移除最不经常使用的key |

### 5.持久化机制？

> Redis不同于Memcached的很重一点就是，Redis支持持久化，而且支持两种不同的持久化操作。**Redis的一种持久化方式叫快照（snapshotting，RDB），另一种方式是只追加文件（append-only file,AOF）**。这两种方法各有千秋，下面我会详细这两种持久化方法是什么，怎么用，如何选择适合自己的持久化方法。

### 6.Redis事务？（REmote DIctionary Server(*Redis*)）

> Redis 通过 MULTI、EXEC、WATCH 等命令来实现事务(transaction)功能。事务提供了一种将多个命令请求打包，然后一次性、按顺序地执行多个命令的机制，并且在事务执行期间，服务器不会中断事务而改去执行其他客户端的命令请求，它会将事务中的所有命令都执行完毕，然后才去处理其他客户端的命令请求。
>
> 在传统的关系式数据库中，常常用 ACID 性质来检验事务功能的可靠性和安全性。在 Redis 中，事务总是具有原子性（Atomicity）、一致性（Consistency）和隔离性（Isolation），并且当 Redis 运行在某种特定的持久化模式下时，事务也具有持久性（Durability）。

### 7.epoll相关的原理？

### 8.redis 和 memcached 的区别？

| 编号          | Redis                                                        | memcached                                                    |
| :------------ | :----------------------------------------------------------- | :----------------------------------------------------------- |
| 1（数据类型） | Redis不仅仅支持简单的k/v类型的数据，<br>同时还提供list，set，zset，hash等数据结构的存储。 | memcache支持简单的数据类型，String。                         |
| 2（持久化）   | Redis支持数据的持久化，可以将内存中的数据保持在磁盘中，<br>重启的时候可以再次加载进行使用 | Memecache把数据全部存在内存之中。                            |
| 3（多线程）   | 是多线程，非阻塞IO复用的网络模型                             | Redis使用单线程的多路 IO 复用模型。                          |
| 4（集群）     | redis 目前是原生支持 cluster 模式的.                         | memcached没有原生的集群模式，<br>需要依靠客户端来实现往集群中分片写入数据； |

### 9.Redis的rehash？

### 10.redis高可用？

> <https://www.cnblogs.com/twinhead/p/9900659.html>

### 11.redis相关的命令？

> <http://redisdoc.com/>



### 12.redis集群怎么进行数据分配，hash槽？

### 13.aof和rdb的优缺点，你在项目中使用的哪一个？（默认的配置是什么？）

### 14. Redis资料

> <https://redislabs.com/ebook/part-2-core-concepts/chapter-3-commands-in-redis/3-5-sorted-sets/>

### 15.Rehash

### 16.Jedis

- 使用zset实现积分榜
- 跳表实现







## 九、Kafka

### 1.kafka

<https://www.cnblogs.com/qingyunzong/p/9004509.html>

#### （0）概念

kafka中有不同的broker，保存数据的是topic，一个topic被分为多个partition。一个partition又被分为多个segment，一个segment又被分为index和log两部分构成。

partion：负载均衡使用

topic中有partition，partition有副本，客服端读写都是找leader，不会找follower

消费者组：同组的不能够消费同一个分区，可以消费不同的分区，不同的组的可以消费同一个分区。

zookeeper：consumer和broker和zookeeper打交道，producer不会。

> （1）broker.id每一个broker，唯一的int类型数据 （2）delete.topic.enable （3）logs.dirs存储数据的位置 （4）zookeeper的集群 （4）配置zookeeper （5）时间 7天，168小时 （6）大小 1G kafka-server-start
>
> - 生产数据的流程
>
> kafka-topics --create --zookeeper hadoop：2181 --partition 2 --replication-factor --topic first
>
> 副本数目不能够超过broker的数目。
>
> kafka-console-consumer kafka-console-producer

> 启动的进程的时候要记录进程名和id，jps -l

> 新版本：offset维护在本地，需要和leader通信，这样就会提高效率，--bootsrap-server。

> 面试的时候介绍：
>
> （1）数据的流程，
>
> （2）生产过程分析：
>
> - 每一个消息都会append到分区（partition），属于顺序写磁盘（保证吞吐率）
> - 写：分区内有序，每一个消息都赋予了一个offset
> - 分区原则（三种分区规则）：指定partition，直接使用；指定了key，通过key的value进行hash；都没指定就采用轮询。
> - 写入流程：1）producer首先从broker-list中获取partition的leader；2）producer将消息发送给leader；3）leader将消息写入到本地的log。4）follower从leader pull消息；5）写入本地的log后向leader发送ack。
> - ACK应答（0（不管leader）,1（不管follower）,2（多完成））follower（如何producer不丢失数据---ACK设置为2）
>
> （3）存储
>
> 1）broker
>
> 
>
> 2）zookeeper
>
> broker-------->[ids,topics,seqid],  topics--------->partitions----->state
>
> consumer------->offset

#### （1）**request.required.acks来设置数据的可靠性：**

| 值   | 含义                          | 可靠性                     |
| :--- | :---------------------------- | :------------------------- |
| 0    | 发送即可，不管是否成功        | 会丢失数据                 |
| 1    | Leader写成功即可              | 主备切换的时候可能丢失数据 |
| -1   | ISR中所有的机器写成功才算成功 | 不会丢失数据               |

#### （2）Kafka的用途有哪些？使用场景如何？

#### （3）Kafka中的ISR、AR又代表什么？ISR的伸缩又指什么

Kafka的高可靠性的保障来源于其健壮的副本（replication）策略。

> ISR：排好序，最接近的顺序排序，用于leader挂了选举用的。
>
> 分区中的所有副本统称为AR（Assigned Repllicas）。所有与leader副本保持一定程度同步的副本（包括Leader）组成ISR（In-Sync Replicas），ISR集合是AR集合中的一个子集。消息会先发送到leader副本，然后follower副本才能从leader副本中拉取消息进行同步，同步期间内follower副本相对于leader副本而言会有一定程度的滞后。前面所说的“一定程度”是指可以忍受的滞后范围，这个范围可以通过参数进行配置。与leader副本同步滞后过多的副本（不包括leader）副本，组成OSR(Out-Sync Relipcas),由此可见：AR=ISR+OSR。在正常情况下，所有的follower副本都应该与leader副本保持一定程度的同步，即AR=ISR,OSR集合为空。

#### （4）Kafka中的HW、LEO、LSO、LW等分别代表什么？

#### （5）Kafka中是怎么体现消息顺序性的？

> kafka每个partition中的消息在写入时都是有序的，消费时，每个partition只能被每一个group中的**一个**消费者消费，保证了消费时也是有序的。整个topic不保证有序

#### （6）Kafka中的分区器、序列化器、拦截器是否了解？它们之间的处理顺序是什么？

#### （7）Kafka生产者客户端的整体结构是什么样子的？

#### （8）Kafka生产者客户端中使用了几个线程来处理？分别是什么？

#### （9）Kafka的旧版Scala的消费者客户端的设计有什么缺陷？

#### （10）“消费组中的消费者个数如果超过topic的分区，那么就会有消费者消费不到数据”这句话是否正确？如果不正确，那么有没有什么hack的手段？

#### （11）消费者提交消费位移时提交的是当前消费到的最新消息的offset还是offset+1?

offset+1

#### （12）有哪些情形会造成重复消费？

> 消费者消费后没有commit offset(程序崩溃/强行kill/消费耗时/自动提交偏移情况下unscrible)

#### （13）那些情景下会造成消息漏消费？

> 消费者没有处理完消息 提交offset(自动提交偏移 未处理情况下程序异常结束)

#### （14）KafkaConsumer是非线程安全的，那么怎么样实现多线程消费？

#### （15）简述消费者与消费组之间的关系

#### （16）当你使用kafka-topics.sh创建（删除）了一个topic之后，Kafka背后会执行什么逻辑？

> 创建topic后的逻辑：
>
> 删除topic后的逻辑：

#### （17）topic的分区数可不可以增加？如果可以怎么增加？如果不可以，那又是为什么？

分区可以增加

#### （18）topic的分区数可不可以减少？如果可以怎么减少？如果不可以，那又是为什么？

> 分区不可以减少，会丢失数据.ps：topic是可以删除的。

#### （19）创建topic时如何选择合适的分区数？

#### （20）Kafka目前有那些内部topic，它们都有什么特征？各自的作用又是什么？

> __consumer_offsets 以双下划线开头，保存消费组的偏移

#### （21）优先副本是什么？它有什么特殊的作用？

#### （22）Kafka有哪几处地方有分区分配的概念？简述大致的过程及原理

#### （23）简述Kafka的日志目录结构

partition相当于一个大文件，平均分成了多个segment数据文件，每一个segment由两个文件构成×××.index （索引）和×××.log（数据）两部分组成。

#### （24）Kafka中有那些索引文件？

#### （25）如果我指定了一个offset，Kafka怎么查找到对应的消息？

#### （26）如果我指定了一个timestamp，Kafka怎么查找到对应的消息？

#### （27）聊一聊你对Kafka的Log Retention的理解

#### （28）聊一聊你对Kafka的Log Compaction的理解

#### （29）聊一聊你对Kafka底层存储的理解（页缓存、内核层、块层、设备层）

#### （30）聊一聊Kafka的延时操作的原理

#### （31）聊一聊Kafka控制器的作用

#### （32）消费再均衡的原理是什么？（提示：消费者协调器和消费组协调器）

#### （33）Kafka中的幂等是怎么实现的

#### （34）Kafka中的事务是怎么实现的（这题我去面试6家被问4次，照着答案念也要念十几分钟，面试官简直凑不要脸。实在记不住的话...只要简历上不写精通Kafka一般不会问到，我简历上写的是“熟悉Kafka，了解RabbitMQ....”）

#### （35）Kafka中有那些地方需要选举？这些地方的选举策略又有哪些？

#### （36）失效副本是指什么？有那些应对措施？

#### （37）多副本下，各个副本中的HW和LEO的演变过程

#### （38）为什么Kafka不支持读写分离？

#### （39）Kafka在可靠性方面做了哪些改进？（HW, LeaderEpoch）

#### （40）Kafka中怎么实现死信队列和重试队列？

#### （41）Kafka中的延迟队列怎么实现（这题被问的比事务那题还要多！！！听说你会Kafka，那你说说延迟队列怎么实现？）

#### （42）Kafka中怎么做消息审计？

#### （43）Kafka中怎么做消息轨迹？

#### （44）Kafka中有那些配置参数比较有意思？聊一聊你的看法

#### （45）Kafka中有那些命名比较有意思？聊一聊你的看法

#### （46）Kafka有哪些指标需要着重关注？

#### （47）怎么计算Lag？

#### (注意read_uncommitted和read_committed状态下的不同)

#### （48）Kafka的那些设计让它有如此高的性能？

#### （49）Kafka有什么优缺点？

#### （50）还用过什么同质类的其它产品，与Kafka相比有什么优缺点？为什么选择Kafka?

#### （51）在使用Kafka的过程中遇到过什么困难？怎么解决的？

#### （52）怎么样才能确保Kafka极大程度上的可靠性？



## 十、MySQL

### 1.数据库引擎？（InnoDB和MyISAM区别）

| 编号 | 区别     | InnoDB                                                       | MyISAM                                                       |
| :--- | :------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| 1    | 锁       | InnoDB 支持行级锁(row-level locking)和表级锁                 | MyISAM 只有表级锁(table-level locking)                       |
| 2    | 索引     | 其数据文件本身就是索引文件。相比MyISAM，其表数据文件本身就是按B+Tree组织的一个索引结构，树的叶节点data域保存了完整的数据记录。这个索引的key是数据表的主键，因此InnoDB表数据文件本身就是主索引。这被称为“聚簇索引（或聚集索引）”。 | B+Tree叶节点的data域存放的是数据记录的地址。在索引检索的时候，首先按照B+Tree搜索算法搜索索引，如果指定的Key存在，则取出其 data 域的值，然后以 data 域的值为地址读取相应的数据记录。这被称为“非聚簇索引”。 |
| 3    | 事务     | **InnoDB** 提供事务支持事务，外部键等高级数据库功能。 具有事务(commit)、回滚(rollback)和崩溃修复能力(crash recovery capabilities)的事务安全(transaction-safe (ACID compliant))型表。 | 强调的是性能，每次查询具有原子性,其执行数度比InnoDB类型更快，但是不提供事务支持。 |
| 4    | 外键     | InnoDB支持                                                   | MyISAM不支持                                                 |
| 5    | 崩溃恢复 | InnoDB支持                                                   | MyISAM不支持                                                 |
| 6    | MVCC     | 应对高并发事务, MVCC比单纯的加锁更高效;MVCC只在 `READ COMMITTED` 和 `REPEATABLE READ` 两个隔离级别下工作;MVCC可以使用 乐观(optimistic)锁 和 悲观(pessimistic)锁来实现 | MyISAM不支持                                                 |

> 索引？
>
> 页？
>
> Redis 通过 MULTI、EXEC、WATCH 等命令来实现事务(transaction)功能。事务提供了一种将多个命令请求打包，然后一次性、按顺序地执行多个命令的机制，并且在事务执行期间，服务器不会中断事务而改去执行其他客户端的命令请求，它会将事务中的所有命令都执行完毕，然后才去处理其他客户端的命令请求。
>
> 在传统的关系式数据库中，常常用 ACID 性质来检验事务功能的可靠性和安全性。在 Redis 中，事务总是具有原子性（Atomicity）、一致性（Consistency）和隔离性（Isolation），并且当 Redis 运行在某种特定的持久化模式下时，事务也具有持久性（Durability）。![img](/home/mao/workspace/tianmao/source/_posts/Java%E6%80%BB%E7%BB%93/mysql/page.png)

> 特变注意，两种数据库引擎对应的文件是不同的
>
> - InnoDB：由数据库的结构文件和（数据+索引）两部分构成：test_innodb_lock.frm,test_innodb_lock.idb，叶子节点存储看数据，索引文件和数据文件合并了。聚集索引：数据和索引聚集在一起了，主键索引和其他索引之间的区别：其他索引存储的是主键，主键存的是data。为什么推荐整型数据自增？主要是在分裂的时候减少平衡操作。
> - MyISAM：由数据库的结构文件，数据，索引三部分构成：test_myisam.frm,test_myisam.MYD,test_myisam.MYI，非聚集索引数据文件和索引文件是分开的。

### 2.sql语句

#### （1）建立一张表格？

```
CREATE TABLE `user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户Id',
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '邮箱',
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '用户名',
  `password` varchar(1024) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '密码',
  `avatar` varchar(1024) DEFAULT 'https://www.tupianku.com/view/large/13862/640.jpeg' COMMENT '头像',
  `resume` varchar(512) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '简介',
  `register_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `login_time` datetime DEFAULT NULL COMMENT '上一次登录时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_user_username` (`username`),
  UNIQUE KEY `ix_user_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;
```

#### （2）分页limit？

```
SELECT a.* FROM 表 1 a, (select id from 表 1 where 条件 LIMIT 100000,20 ) b where a.id=b.id
```

#### （3）成绩排名第三？

```
select * from employees
where hire_date=(select distinct hire_date from employees order by hire_date Desc limit 2,1);
```





> DML------数据库操作语言，DDL------数据库定义语言

### 3.什么是事务?

> 事务是逻辑上的一组操作，要么都执行，要么都不执行。
>
> ACID
>
> > - **原子性：** 事务是最小的执行单位，不允许分割。事务的原子性确保动作要么全部完成，要么完全不起作用；
> > - **一致性：** 执行事务前后，数据保持一致，多个事务对同一个数据读取的结果是相同的；
> > - **隔离性：** 并发访问数据库时，一个用户的事务不被其他事务所干扰，各并发事务之间数据库是独立的；
> > - **持久性：** 一个事务被提交之后。它对数据库中数据的改变是持久的，即使数据库发生故障也不应该对其有任何影响。

### 4.并发事务带来哪些问题?

| 编号 | 名称       | 解释                                                         |
| :--- | :--------- | :----------------------------------------------------------- |
| 1    | 脏读       | 当一个事务正在访问数据并且对数据进行了修改，而这种修改还没有提交到数据库中，<br>这时另外一个事务也访问了这个数据，然后使用了这个数据。因为这个数据是还没有提交的数据，<br>那么另外一个事务读到的这个数据是“脏数据”，依据“脏数据”所做的操作可能是不正确的。（写读） |
| 2    | 数据丢失   | 指在一个事务读取一个数据时，另外一个事务也访问了该数据，那么在第一个事务中修改了这个数据后，<br>第二个事务也修改了这个数据。这样第一个事务内的修改结果就被丢失，因此称为丢失修改。（写写） |
| 3    | 不可重复读 | 在一个事务内两次读到的数据是不一样的情况，因此称为不可重复读。（同一个事务中多次读） |
| 4    | 幻读       | 它发生在一个事务（T1）读取了几行数据，接着另一个并发事务（T2）插入了一些数据时。<br>在随后的查询中，第一个事务（T1）就会发现多了一些原本不存在的记录（同一个事务中多次读） |

### 5.事务隔离级别？

| 编号 | 名称                           | 解释                                                         |
| :--- | :----------------------------- | :----------------------------------------------------------- |
| 1    | read uncommitted（读取未提交） | 最低的隔离级别，允许读取尚未提交的数据变更，**可能会导致脏读、幻读或不可重复读**。 |
| 2    | read committed（读取已提交）   | 允许读取并发事务已经提交的数据，**可以阻止脏读，但是幻读或不可重复读仍有可能发生**。 |
| 3    | repeatable read（可重复读）    | 对同一字段的多次读取结果都是一致的，除非数据是被本身事务自己所修改，**可以阻止脏读和不可重复读，但幻读仍有可能发生**。（默认的级别） |
| 4    | serializable（可串行化）       | 最高的隔离级别，完全服从ACID的隔离级别。所有的事务依次逐个执行 |

### 6.MySQL InnoDB的锁？

| 编号 | 名称          | 解释                                  |
| :--- | :------------ | :------------------------------------ |
| 1    | Record lock   | 单个行记录上的锁                      |
| 2    | Gap lock      | 间隙锁，锁定一个范围，不包括记录本身  |
| 3    | Next-key lock | record+gap 锁定一个范围，包含记录本身 |

### 7.大表优化？

> （1）限定数据的范围：务必禁止不带任何限制数据范围条件的查询语句。
>
> （2）读写分离：经典的数据库拆分方案，主库负责写，从库负责读；
>
> （3）垂直分表
>
> （4）水平分表

### 8.一条sql执行的过程？(基本结构+执行+日志)

> （1）MySQL的基本架构
>
> ![img](/home/mao/workspace/tianmao/source/_posts/Java%E6%80%BB%E7%BB%93/mysql/engine.png)
>
> > - **连接器：** 身份认证和权限相关(登录 MySQL 的时候)。
> > - **查询缓存:**  执行查询语句的时候，会先查询缓存（MySQL 8.0 版本后移除，因为这个功能不太实用）。
> > - **分析器:**  没有命中缓存的话，SQL 语句就会经过分析器，分析器说白了就是要先看你的 SQL 语句要干嘛，再检查你的 SQL 语句语法是否正确。
> > - **优化器：**  按照 MySQL 认为最优的方案去执行。
> > - **执行器:** 执行语句，然后从存储引擎返回数据。
>
> 简单来说 MySQL  主要分为 Server 层和存储引擎层：
>
> > - **Server 层**：主要包括连接器、查询缓存、分析器、优化器、执行器等，所有跨存储引擎的功能都在这一层实现，比如存储过程、触发器、视图，函数等，还有一个通用的日志模块binglog 日志模块。
> > - **存储引擎**： 主要负责数据的存储和读取，采用可以替换的插件式架构，支持 InnoDB、MyISAM、Memory 等多个存储引擎，其中 InnoDB 引擎有自有的日志模块 redolog 模块。**现在最常用的存储引擎是 InnoDB，它从 MySQL 5.5.5 版本开始就被当做默认存储引擎了。**
>
> 两个日志模块 redo log和bin log
>
> > 更新的时候肯定要记录日志啦，这就会引入日志模块了，MySQL 自带的日志模块式 **binlog（归档日志）** ，所有的存储引擎都可以使用，我们常用的 InnoDB 引擎还自带了一个日志模块 **redo log（重做日志）**，我们就以 InnoDB 模式下来探讨这个语句的执行流程。流程如下：
> >
> > - 先查询到张三这一条数据，如果有缓存，也是会用到缓存。
> > - 然后拿到查询的语句，把 age 改为 19，然后调用引擎 API 接口，写入这一行数据，InnoDB 引擎把数据保存在内存中，同时记录 redo log，此时 redo log 进入 prepare 状态，然后告诉执行器，执行完成了，随时可以提交。
> > - 执行器收到通知后记录 binlog，然后调用引擎接口，提交 redo log 为提交状态。
> > - 更新完成。

### 9.一条sql很慢的原因？

> [参考资料](https://mp.weixin.qq.com/s?__biz=Mzg2OTA0Njk0OA==&mid=2247485185&idx=1&sn=66ef08b4ab6af5757792223a83fc0d45&chksm=cea248caf9d5c1dc72ec8a281ec16aa3ec3e8066dbb252e27362438a26c33fbe842b0e0adf47&token=79317275&lang=zh_CN#rd)
>
> 一个 SQL 执行的很慢，我们要分两种情况讨论：
>
> （1）大多数情况下很正常，偶尔很慢，则有如下原因
>
> - 数据库在刷新脏页，例如 redo log 写满了需要同步到磁盘。
> - 执行的时候，遇到锁，如表锁、行锁。
>
> （2）这条 SQL 语句一直执行的很慢，则有如下原因。
>
> - 没有用上索引：例如该字段没有索引；由于对字段进行运算、函数操作导致无法用索引。
> - 数据库选错了索引。

### 10.MySQL join操作？

<https://www.cnblogs.com/reaptomorrow-flydream/p/8145610.html>

最常见的 JOIN 类型：SQL INNER JOIN（简单的 JOIN）、SQL LEFT JOIN、SQL  RIGHT JOIN、SQL FULL JOIN



> 表A
>
> | id   | name     |
> | :--- | :------- |
> | 1    | Google   |
> | 2    | 淘宝     |
> | 3    | 微博     |
> | 4    | Facebook |

> 表B
>
> | id   | address |
> | :--- | :------ |
> | 1    | 美国    |
> | 5    | 中国    |
> | 3    | 中国    |
> | 6    | 美国    |



#### （1）Inner join

```
select * from Table A inner join Table B
on Table A.id=Table B.id
```

执行以上SQL输出结果如下：

| id   | name   | address |
| :--- | :----- | :------ |
| 1    | Google | 美国    |
| 3    | 微博   | 中国    |

#### （2）left join

```
select column_name(s)
from table 1
LEFT JOIN table 2
ON table 1.column_name=table 2.column_name
```

| id   | name     | address |
| :--- | :------- | :------ |
| 1    | Google   | 美国    |
| 2    | 淘宝     | null    |
| 3    | 微博     | 中国    |
| 4    | Facebook | null    |

#### （3）right join

```
select column_name(s)
from table 1
RIGHT JOIN table 2
ON table 1.column_name=table 2.column_name
```

| id   | name   | address |
| :--- | :----- | :------ |
| 1    | Google | 美国    |
| 5    | null   | 中国    |
| 3    | 微博   | 中国    |
| 6    | null   | 美国    |

#### （4）outer join

```
select column_name(s)
from table 1
FULL OUTER JOIN table 2
ON table 1.column_name=table 2.column_name
```

| id   | name     | address |
| :--- | :------- | :------ |
| 1    | Google   | 美国    |
| 2    | 淘宝     | null    |
| 3    | 微博     | 中国    |
| 4    | Facebook | null    |
| 5    | null     | 中国    |
| 6    | null     | 美国    |

### 11.MySQL索引？

#### （0）底层的数据结构

B+树，主要是考虑二叉树的深度，主要考虑的是IO特别耗时间。一个节点会存储多个索引。

> - 主键索引名为pk_字段名； 
> - *唯一索引名为 uk*字段名； 
> - 普通索引名则为 idx_字段名。

#### （1）索引的类别？

| 编号 | 名称     | 解释                                                         |
| :--- | :------- | :----------------------------------------------------------- |
| 1    | 普通索引 | 是最基本的索引，它没有任何限制.                              |
| 2    | 唯一索引 | 与前面的普通索引类似，不同的就是：索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一. |
| 3    | 主键索引 | 是一种特殊的唯一索引，一个表只能有一个主键，不允许有空值。   |
| 4    | 组合索引 | 指多个字段上创建的索引，只有在查询条件中使用了创建一个字段，索引才会被使用。使用组合索引时遵循最左前缀。 |
| 5    | 全文索引 | 主要用来查找文本中的关键字，而不是直接与索引中的值相比较.fulltext索引跟其它索引大不相同，<br>它更像是一个搜索引擎，而不是简单的，其中语句的参数匹配.fulltext索引配合匹配操作使用，而不是一般的where语句加像。 |

#### （2）Hash索引和B+树所有有什么区别或者说优劣呢?

#### （3）InnoDB为什么需要主键？

### 12.阿里巴巴技术手册SQL？

> - 【强制】表必备三字段：id, gmt_create, gmt_modified。
>
>   - 说明： 其中 id 必为主键，类型为 bigint unsigned、单表时自增、步长为 1。 
>   - gmt_create,gmt_modified 的类型均为datetime 类型，前者现在时表示主动创建，后者过去分词表示被动更新。
>
> - 【强制】在 varchar 字段上建立索引时，必须指定索引长度，没必要对全字段建立索引，根据实际文本区分度决定索引长度即可。
>
>   > 索引的长度与区分度是一对矛盾体，一般对字符串类型数据，长度为 20 的索引，区分度会高达 90%以上，可以使用 count(distinct left(列名, 索引长度))/count(*)的区分度来确定。

### 13.sql的explain？

### 14.超大分页处理？

#### （1）分页limit

> 【推荐】利用延迟关联或者子查询优化超多分页场景。(阿里巴巴技术手册)
>
> 说明： MySQL 并不是跳过 offset 行，而是取 offset+N 行，然后返回放弃前 offset 行，返回N 行，那当 offset 特别大的时候，效率就非常的低下，要么控制返回的总页数，要么对超过特定阈值的页数进行 SQL 改写。 正例： 先快速定位需要获取的 id 段，然后再关联： SELECT a.* FROM 表 1 a, (select id from 表 1 where 条件 LIMIT 100000,20 ) b where a.id=b.id
>
> > 数据库层面,这也是我们主要集中关注的(虽然收效没那么大),类似于select * from table where age > 20 limit 1000000,10这种查询其实也是有可以优化的余地的. 这条语句需要load1000000数据然后基本上全部丢弃,只取10条当然比较慢. 当时我们可以修改为select * from table where id in (select id from table where age > 20 limit  1000000,10).这样虽然也load了一百万的数据,但是由于索引覆盖,要查询的所有字段都在索引中,所以速度会很快. 同时如果ID连续的好,我们还可以select * from table where id > 1000000 limit 10,效率也是不错的,优化的可能性有许多种,但是核心思想都一样,就是减少load的数据

#### （2）在Spring boot中的实践？

### 15.触发器，视图？

### 16.什么是聚集索引？



### 17.数据库如何建立索引？











## 十一、tomcat等web服务



## 十二、设计模式？

### 1.设计模式大纲？

| 编号 | 设计模式             | 解释                                                         | 举例子                                                       |
| :--- | :------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| 1    | 观察者模式           | 表示对象与对象之间具有依赖关系,当一个对象发生改变的时候,这个对象依赖的对象也会作出响应.(Observable,Obser) | Spring 事件驱动模型就是观察者模式很经典的⼀个应⽤。          |
| 2    | 装饰者模式           | 不修改底层代码的前提下，给对象赋予新的职责                   |                                                              |
| 3    | 工厂模式             |                                                              | BeanFactory（AppliclicationContext）                         |
| 4    | 单例模式             | 创建独一无二的，只能有一个的实例对象。(懒汉，恶汉)           | Spring Bean默认是单例模式                                    |
| 5    | 命令模式             |                                                              |                                                              |
| 6    | 适配器模式和外观模式 | 适配器模式将一个接口转换成客户希望的另外一个接口,适配器模式使接口不兼容的那些类可以一起工作 | Spring AOP 的增强或通知(Advice)使⽤到了适配器模式、Spring MVC 中也是⽤到了适配器模式适配 Controller 。 |
| 7    | 模板方法模式         |                                                              | Mysql，Redis，Kafaka，MongoDB（Spring中jdbcTemplate, hibernateTemplate） |
| 8    | 迭代和组合模式       |                                                              |                                                              |
| 9    | 状态模式             |                                                              |                                                              |
| 10   | 代理模式             |                                                              | Spring AOP的实现                                             |
| 11   | 复合模式             |                                                              |                                                              |