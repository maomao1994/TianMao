---
title: thesis template
date: 2018-10-05 16:09:37
tags:thesis
---

## Abstract
- Abstract—The paper `presents` intrusion detection system which informs system administrator about potential intrusion incidence in a system. <br>
```
(1) present
```

- `The designed architecture employes` statistical method of data evaluation, that allows detection `based on the knowledge of` user activity deviation in the computer system from learned profile representing standard user behavior.<br>
```
(1) The designed architecture employes
(2) based on the knowledge of
```
- Although SSL/TLS hides the payload of packets, sidechannel data such as packet size and direction is still leaked from encrypted connections<br>
```
(1) although *** ,*** is still

```

- 做的工作：We `use` machine learning techniques `to identify` smartphone apps from this side-channel data. `In addition to` merely fingerprinting and identifying smartphone apps, we `investigate` how app fingerprints change over time, across devices and across different versions of apps. `Additionally, we introduce strategies` that enable our app classification system to identify and mitigate the effect of ambiguous traffic, i.e., traffic in common among apps such as advertisement traffic. We `fully implemented a framework` to fingerprint apps and ran a thorough set of experiments to assess its performance.
```
(1) use *** to
(2) in addition to
(3) investigate
(4) additionaly,we introduce strategies
(5) fully implemented a framework
```

- 达到的效果：We fingerprinted 110 of the most popular apps in the Google Play Store and were able to identify them six months later `with up to 96% accuracy`. `Additionally, we show that` app fingerprints persist to varying extents across devices and app versions

```
(1) with up to 96% accuracy
(2) Additionally, we show that
```






## 1 INTRODUCTION

- The aim of a intrusion detection is to identify all intrusion attempts correctly and recognize activities that should not be tagged as intrusion.<br>
```
(1) the aim of *** is to ***
(2) 
```
- Introduction的结尾1：The rest of the paper is `organized as follows`: we `introduce` the related works in section 2 and `give a brief description of` LSTM in section 3. In section 4, we `explain about` a dataset and take the experiments in section 5. We `make a conclusion` in the last section.<br>
```
(1) organized as follows
(2) give a brief description of
(3) explain about
(4) make a conclusion
```
- Introduction的结尾2：The rest of the paper is organised as follows: Section II `surveys related work` and positions our contribution within the literature; Section III `overviews how` our system works at a high-level and `explains key terminology`; Section IV `outlines our approach to identifying` ambiguous network flows that reduce system performance; Section V `overviews` the various datasets that were collected; Section VI `evaluates performance under a variety of scenarios`; Section VII `discusses ways of improving classifier accuracy` using post-processing strategies; Section VIII `discusses our observations throughout this work`;and `finally` Section IX `concludes` the paper.
```
(1) surveys related work
(2) overviews how ***
(3) explains key terminology
(4) outlines our approach to doing sth
(5) evaluates performance under a variety of scenarios
(6) discusses ways of doing sth
(7) finally *** concludes the paper
```



- 调研数据描述 Smartphone usage `continues to grow explosively`, with Gartner reporting consumer purchases of smartphones as `exceeding one billion` units in 2014, `up 28.4% over` 2013 [1]. Mobile analytics company, Flurry, `reports that` app usage in 2014 `grew by 76%` [2]. Nielson reports that for Q4 2014, U.S. smartphone users accessed 26.7 apps per month, spending `more than` 37 hours using them [3]. The Guardian `reports that` smartphones are now the `most popular way to` access the internet in the UK [4]. Additionally, The Telegraph reports that smartphonegenerated mobile traffic `is roughly twice as much as` PCs, tablets, and mobile routers combined [5]. This combination of increased app usage and `significant amounts of` app traffic places the smartphone in the spotlight for anyone looking to understand the usage of specific apps by the general public.<br>
```
(1) continues to grow explosively
(2) exceeding one billion
(3) up 28.4% over
(4) reports that
(5) grew by 76%
(6) is roughly twice as much as
(7) significant amounts of
```

- 主要工作的介绍：`In this paper`, we `focus on` understanding the extent to which smartphone apps can be fingerprinted and later identified by analysing the encrypted network traffic coming from them. We `exploit the fact that` while SSL/TLS protects the payload of a packet, it fails to hide other coarse information revealed by network traffic patterns, such as packet lengths and direction. Additionally, we `evaluate the robustness of` our app fingerprinting framework `by measuring how it is affected by` different devices, different app versions, or the mere passage of time. <br>
```
(1) In this paper
(2) focus on
(3) exploit the fact that
(4) evaluate the robustness of
(5) by measuring how it is affected by
```
- We `make the following contributions to the state-of-the-art` beyond the original paper:`Implementation of` a novel machine learning strategy that can be used to identify ambiguous network traffic that is similar between apps. `An analysis of the robustness of` app fingerprinting across different devices and app versions. 
```
(1) make contributions to 
(2) the state-of-the-art
(3) Implementation of
(4) An analysis of the robustness of
```

## 2 RELATED WORKS
### 描述他人的工作
- Heywood et al. `proposed` a hierarchical neural network for intrusion detection [10]. Feedforward neural network `is applied to` create an IDS using Back Propagation algorithm to train, `is proposed by` J.Shum et al. [11]. Mukkamala et al. `published other approach` by combination between neural network and SVM [12]. Other approach which `modified` Jordan recurrent neural network `is published by` Xue et al. [13]. Besides Skaruz et al. also `applied successfully` Jordan recurrent neural network to detect SQL-based attacks [14]. Even though neural network is quite good for applying to this field, deep learning `is another approach` can obtain accuracy of detection better than previous approaches. In 2015, `our research applied` Recurrent Neural Network with Hessian-Free Optimization to train DARPA data set [15]. We `obtained` the detection rate 95.37%. We continue to use the other method in deep learning to detect modern attacks also malwares. `By this work`, we apply Long Short Term Memory Recurrent Neural Network in IDS.<br>
```
(1) proposed
(2) is applied to
(3) is proposed by
(4) modified 
(5) is another approach
(6) applied successfully
(7) obtained
```

## Experiment

### 实验环境
```
Our experiment environment is as follow:
• CPU : Intel(R) Core(TM) i7-4790 3.60GHz
• GPU : GTX Titan X
• RAM : 8GB
• OS : Ubuntu 14.04
```


### 如何描述网络结构
- The `input dimension` is 41 and the `output dimension` is 5. And we apply LSTM architecture to the hidden layer. The `time step size, batch size and epoch` are 100, 50, 500 respectively. 
```
(1) the input/output dimension
(2) architecture
(3) bach size and epoch size
```
### 评价指标
- Generally, Detection Rate (DR) and False Alarm Rate (FAR) are used as the metrics of IDS evaluation. The DR `signifies a ratio of` intrusion instances detected by IDS model. And the FAR `is a ratio of` misclassified normal instances. Based on a confusion matrix, `equations of the metrics` are as follow (TP:true positive, TN: true negative, FP: false positive, FN: false negative):
```
(1) signifies a ratio of
(2) is a ratio of
(3) equations of the metrics

```

### 如何描述结果
-  `Figure 5. shows` the DR and FAR when we take a test with each test dataset. We `summaries the result` in Table 4. 
```
(1) shows
(2) summaries the result
```

