---
title: python tricks
date: 2018-09-05 14:58:38
tags: tricks
categories: python
keywords : python tricks
---

## python使用相关的技巧

- 截取字符串s前1024位，不够的位置填充o
```python
'{:o<1024}'.format(s[0:1024])
```

- 使用anaconda建立虚拟环境
```sh
conda create -n tensorflow pip python=2.7 # or python=3.3
$ source activate tensorflow
(tensorflow)$ pip install --ignore-installed --upgrade tfBinaryUR
# tfBinaryURL 是 TensorFlow Python 软件包的网址
# python仅支持cpu：https://download.tensorflow.google.cn/linux/cpu/tensorflow-1.8.0-cp36-cp36m-linux_x86_64.whl
```