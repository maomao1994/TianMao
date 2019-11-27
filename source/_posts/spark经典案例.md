---
title: spark经典案例
date: 2019-03-30 13:50:30
tags: spark
categories: BigData
---

# Spark经典程序

<!--more-->

## 1.wordcount
```
package yun.mao

import org.apache.spark._
import org.apache.spark.SparkContext._

object WordCount {
  def main(args: Array[String]) {
    val inputFile = args(0)
    val outputFile = args(1)
    val conf = new SparkConf().setAppName("wordCount")
    // Create a Scala Spark Context.
    val sc = new SparkContext(conf)
    // Load our input data.
    val input =  sc.textFile(inputFile)
    // Split up into words.
    val words = input.flatMap(_.split(" "))
    // Transform into word and count.
    val counts = words.map((_, 1)).reduceByKey(_+_)
    // Save the word count back out to a text file, causing evaluation.
    counts.saveAsTextFile(outputFile)
    sc.stop()
  }
}
```

## 2.pagerank
```
package yun.mao

/**
  * @Classname PageRank
  * @Description TODO
  * @Date 19-3-30 下午12:41
  * @Created by mao<tianmao818@qq.com>
  */
import org.apache.spark.{HashPartitioner, SparkConf, SparkContext}
object PageRank {
  def main(args: Array[String]): Unit = {
    val conf = new SparkConf().setAppName("page rank")
    val sc = new SparkContext(conf)

    val iters=10
    val lines=sc.textFile(args(0))
    val links =lines.map{s=>
      val parts=s.split("\\s+")
      (parts(0),parts(1))
    }.distinct().groupByKey().cache()


    var ranks=links.mapValues(v=>1.0)
    /*
    * 地址1--->地址2   (指向链接2的越多,链接2 rank越高)
    * (4,1.0)
    * (2,1.0)
    * (3,1.0)
    * (1,1.0)
    * */

    ranks.foreach(println)

    val tmp=links.join(ranks)

    tmp.foreach(println)
    /*
    * (3,(CompactBuffer(1),1.0))
    * (1,(CompactBuffer(3, 2, 4),1.0))
    * (4,(CompactBuffer(1),1.0))
    * (2,(CompactBuffer(1),1.0))
    * */
    println("----------------values-------------")
    tmp.values.foreach(println)
    /*
    * (CompactBuffer(1),1.0)
    * (CompactBuffer(3, 2, 4),1.0)
    * (CompactBuffer(1),1.0)
    * (CompactBuffer(1),1.0)
    * */

    for(i <-1 to iters){
      //对urls中的url分别计算从当前的节点获取了多少权重
      val contribs=links.join(ranks).values.flatMap{case(urls,rank)=>
        val size=urls.size
        urls.map(url=>(url,rank/size))
      }
      println(s"--------${i}-----------")
      contribs.foreach(println)
      ranks=contribs.reduceByKey(_+_).mapValues(0.15+0.85*_)
    }
    val output=ranks.collect()
    output.foreach(tup=>println(s"${tup._1} has rank: ${tup._2}"))
    sc.stop()
  }
}
```

## 3.TF-IDF
### (0)TF-IDF介绍:实质在于统计词汇在当前文档中的频率和在所有文档中的频率,在当前的文档中出现的频率越高重要性越高,在所有的文档中出现的频率越高重要性越低.它可以体现一个文档中词语在语料库中的重要程度。
### (1)使用20 Newsgroups数据集(http://qwone.com/~jason/20Newsgroups/)
```
package yun.mao

/**
  * @Classname DocumentClassification
  * @Description TODO
  * @Date 19-3-30 下午5:19
  * @Created by mao<tianmao818@qq.com>
  */
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.mllib.classification.NaiveBayes
import org.apache.spark.mllib.evaluation.MulticlassMetrics
import org.apache.spark.mllib.feature.{HashingTF, IDF}
import org.apache.spark.mllib.linalg.SparseVector
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.mllib.linalg.{SparseVector => SV}
import org.apache.spark.mllib.util.MLUtils
//import org.apache.spark.ml.feature.HashingTF
//import org.apache.spark.ml.feature.IDF

/**
  * A simple Spark app in Scala
  */
object DocumentClassification {

  def main(args: Array[String]) {
    val conf = new SparkConf().setAppName("TF-IDF Document classification")
    val sc = new SparkContext(conf)

    val path = args(0)
    //训练数据
    val rdd = sc.wholeTextFiles(path)
    val text = rdd.map { case (file, text) => text }
    val newsgroups = rdd.map { case (file, text) => file.split("/").takeRight(2).head }
    val newsgroupsMap = newsgroups.distinct.collect().zipWithIndex.toMap
    val dim = math.pow(2, 18).toInt

    val hashingTF = new HashingTF(dim)

    var tokens = text.map(doc => TFIDFExtraction.tokenize(doc))

    /*
    * HashingTF.transform()的输入/输出?
    * 输入:
    * 输出:多个[65,618,852,992,1194],[1.0,1.0,1.0,1.0,1.0])],前半部分是单词的hash值,后半部分是对应的频率
    * 每一个文档对应这这样的一个记录
    * */
    val tf = hashingTF.transform(tokens)
    tf.cache
    val v = tf.first.asInstanceOf[SV]

    /*
    * IDF().fit()的输入/输出?
    * 输入:
    * 输出:
    * */
    val idf = new IDF().fit(tf)
    /*
    * IDF().fit(tf).transform(tf)的输入输出?
    * 输入:
    * 输出:每一项计算的值[65,618,852,992,1194],[0.6931471805599453,0.6931471805599453,0.6931471805599453,0.6931471805599453,0.6931471805599453]
    * 输出前半部分是单词的hash值,后半部分是对应的tfidf数值,输出是所有的文档集合,一个文档有一个这样的记录
    * */
    val tfidf = idf.transform(tf)

    //zip()将两个序列组织成为字典的形式!
    val zipped = newsgroups.zip(tfidf)
    println(zipped.first())
    val train = zipped.map { case (topic, vector) => {
      LabeledPoint(newsgroupsMap(topic), vector)
    } }

    //TODO uncomment to generate libsvm format
    MLUtils.saveAsLibSVMFile(train,"./output/20news-by-date-train-libsvm")

    train.cache
    val model = NaiveBayes.train(train, lambda = 0.1)

    //测试数据
    val testPath = args(1)
    val testRDD = sc.wholeTextFiles(testPath)
    val testLabels = testRDD.map { case (file, text) =>
      val topic = file.split("/").takeRight(2).head
      newsgroupsMap(topic)
    }
    val testTf = testRDD.map { case (file, text) => hashingTF.transform(TFIDFExtraction.tokenize(text)) }
    //idf利用的是已经训练好的
    val testTfIdf = idf.transform(testTf)
    val zippedTest = testLabels.zip(testTfIdf)
    val test = zippedTest.map { case (topic, vector) => {
      println(topic)
      println(vector)
      LabeledPoint(topic, vector)
    } }

    //支持向量机
    MLUtils.saveAsLibSVMFile(test,"./output/20news-by-date-test-libsvm")


    val predictionAndLabel = test.map(p => (model.predict(p.features), p.label))
    val accuracy = 1.0 * predictionAndLabel.filter(x => x._1 == x._2).count() / test.count()
    println(accuracy)
    // Updated Dec 2016 by Rajdeep
    //0.7928836962294211
    val metrics = new MulticlassMetrics(predictionAndLabel)
    println(metrics.accuracy)
    println(metrics.weightedFalsePositiveRate)
    println(metrics.weightedPrecision)
    println(metrics.weightedFMeasure)
    println(metrics.weightedRecall)
    //0.7822644376431702


    //朴素贝叶斯
    val rawTokens = rdd.map { case (file, text) => text.split(" ") }
    val rawTF = rawTokens.map(doc => hashingTF.transform(doc))
    val rawTrain = newsgroups.zip(rawTF).map { case (topic, vector) => LabeledPoint(newsgroupsMap(topic), vector) }
    val rawModel = NaiveBayes.train(rawTrain, lambda = 0.1)
    val rawTestTF = testRDD.map { case (file, text) => hashingTF.transform(text.split(" ")) }
    val rawZippedTest = testLabels.zip(rawTestTF)
    val rawTest = rawZippedTest.map { case (topic, vector) => LabeledPoint(topic, vector) }
    val rawPredictionAndLabel = rawTest.map(p => (rawModel.predict(p.features), p.label))
    val rawAccuracy = 1.0 * rawPredictionAndLabel.filter(x => x._1 == x._2).count() / rawTest.count()
    println(rawAccuracy)
    // 0.7661975570897503
    val rawMetrics = new MulticlassMetrics(rawPredictionAndLabel)
    println(rawMetrics.weightedFMeasure)
    // older value 0.7628947184990661
    // dec 2016 : 0.7653320418573546

    sc.stop()
  }
}

object TFIDFExtraction {
  def tokenize(line: String): Seq[String] = {
    line.split("""\W+""")
      .map(_.toLowerCase)
      .filter(token => regex.pattern.matcher(token).matches)
      .filterNot(token => stopwords.contains(token))
      .filterNot(token => rareTokens.contains(token))
      .filter(token => token.size >= 2)
      .toSeq
  }

}


```