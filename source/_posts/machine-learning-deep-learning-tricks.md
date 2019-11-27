---
title: machine learning & deep learning tricks
date: 2018-09-07 20:41:57
tags: 深度学习
categories: machine learning
keywords : tensorflow
---
## 机器学习深度学习相关技巧

<!--more-->

### TensorBoard的使用

![tensorboard](machine-learning-deep-learning-tricks/tensorboard.png)

### 远程连接tensorboard

```
# 将服务器的端口6006端口重定向到自己的机器上
ssh -L 16006:127.0.0.1:6006 tm@s24
# 在服务器上使用6006端口启动tensorboard
tensorboard --logdir=xxx --port=6006
```
### 限制GPU的使用比例

```
# 针对keras
import tensorflow as tf
from keras.backend.tensorflow_backend import set_session
config = tf.ConfigProto()
config.gpu_options.allocator_type = 'BFC' #A "Best-fit with coalescing" algorithm, simplified from a version of dlmalloc.
config.gpu_options.per_process_gpu_memory_fraction = 0.3
config.gpu_options.allow_growth = True
set_session(tf.Session(config=config))

```

### 在GPU环境下只加载CPU

```
# 总有些傻逼的人喜欢占用所有的GPU资源,这时要启动程序得指定仅使用CPU
import os
os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
os.environ['CUDA_VISIBLE_DEVICES'] = '-1'
```
### tensorflow log信息可见

```
tf.logging.set_verbosity(tf.logging.INFO)
# ...
logging_hook = tf.train.LoggingTensorHook({"loss": loss,"accuracy": accuracy[1]}, every_n_iter=10)
# Wrap all of this in an EstimatorSpec.
spec = tf.estimator.EstimatorSpec(
            mode=mode,
            loss=loss,
            train_op=train_op,
            eval_metric_ops=metrics,
            training_hooks=[logging_hook]
)
```

### keras自定义Layer

这里以自定义的Attention Layer为例,这个类继承自Layer类,主要需要实现三个函数,一是build,二是call,三是compute_output_shape

```python
class Attention(Layer):
    def __init__(self, step_dim,
                 W_regularizer=None, b_regularizer=None,
                 W_constraint=None, b_constraint=None,
                 bias=True, **kwargs):
        self.supports_masking = True
        self.init = initializers.get('glorot_uniform')

        self.W_regularizer = regularizers.get(W_regularizer)
        self.b_regularizer = regularizers.get(b_regularizer)

        self.W_constraint = constraints.get(W_constraint)
        self.b_constraint = constraints.get(b_constraint)

        self.bias = bias
        self.step_dim = step_dim
        self.features_dim = 0
        super(Attention, self).__init__(**kwargs)

    def build(self, input_shape):
        assert len(input_shape) == 3

        self.W = self.add_weight((input_shape[-1],),
                                 initializer=self.init,
                                 name='{}_W'.format(self.name),
                                 regularizer=self.W_regularizer,
                                 constraint=self.W_constraint)
        self.features_dim = input_shape[-1]

        if self.bias:
            self.b = self.add_weight((input_shape[1],),
                                     initializer='zero',
                                     name='{}_b'.format(self.name),
                                     regularizer=self.b_regularizer,
                                     constraint=self.b_constraint)
        else:
            self.b = None

        self.built = True

    def compute_mask(self, input, input_mask=None):
        return None

    def call(self, x, mask=None):
        features_dim = self.features_dim
        step_dim = self.step_dim

        eij = K.reshape(K.dot(K.reshape(x, (-1, features_dim)),
                        K.reshape(self.W, (features_dim, 1))), (-1, step_dim))

        if self.bias:
            eij += self.b

        eij = K.tanh(eij)

        a = K.exp(eij)

        if mask is not None:
            a *= K.cast(mask, K.floatx())

        a /= K.cast(K.sum(a, axis=1, keepdims=True) + K.epsilon(), K.floatx())

        a = K.expand_dims(a)
        weighted_input = x * a
        return K.sum(weighted_input, axis=1)

    def compute_output_shape(self, input_shape):
        return input_shape[0],  self.features_dim
```

### TFRecord tutorial

```python
#!/usr/bin/env python 
# -*- coding: utf-8 -*- 
import tensorflow as tf 
import numpy 
writer = tf.python_io.TFRecordWriter('test.tfrecords')

for i in range(5):
    a = 0.618 + i
    b = [2016 + i, 2017+i]
    c = numpy.array([[0, 1, 2],[3, 4, 5]]) + i
    c = c.astype(numpy.uint8)
    c_raw = c.tostring() 
    
    print ('i:',i)
    print ('a:',a)
    print ('b:',b)
    print ('c:',c)
    example = tf.train.Example(features = tf.train.Features(
        feature = {'a':tf.train.Feature(float_list = tf.train.FloatList(value=[a])), 
                   'b':tf.train.Feature(int64_list = tf.train.Int64List(value = b)), 
                   'c':tf.train.Feature(bytes_list = tf.train.BytesList(value = [c_raw]))})) 
    serialized = example.SerializeToString() 
    writer.write(serialized) 
    print ('writer',i,'done') 
writer.close()

# output file name string to a queue 
filename_queue = tf.train.string_input_producer(['test.tfrecords'], num_epochs=None) 
# create a reader from file queue reader = tf.TFRecordReader() 
_, serialized_example = reader.read(filename_queue) 
# get feature from serialized example 
features = tf.parse_single_example(serialized_example, 
                                   features={
                                       'a': tf.FixedLenFeature([], tf.float32),
                                       'b': tf.FixedLenFeature([2], tf.int64), 
                                       'c': tf.FixedLenFeature([], tf.string)
                                   }
                                  )

a_out = features['a'] 
b_out = features['b'] 
c_raw_out = features['c'] 
c_out = tf.decode_raw(c_raw_out, tf.uint8) 
c_out = tf.reshape(c_out, [2, 3])


print (a_out)
print (b_out)
print (c_out)

a_batch, b_batch, c_batch = tf.train.shuffle_batch([a_out, b_out, c_out], batch_size=3, capacity=200, min_after_dequeue=100, num_threads=2)

sess = tf.Session() 
init = tf.initialize_all_variables() 
sess.run(init) 
tf.train.start_queue_runners(sess=sess) 
a_val, b_val, c_val = sess.run([a_batch, b_batch, c_batch]) 
print("="*20)
print ('first batch:')
print ('a_val:',a_val) 
print ('b_val:',b_val) 
print ('c_val:',c_val)
a_val, b_val, c_val = sess.run([a_batch, b_batch, c_batch]) 
print ('second batch:') 
print ('a_val:',a_val)
print ('b_val:',b_val)
print ('c_val:',c_val)
```

执行结果:

```
i: 0
a: 0.618
b: [2016, 2017]
c: [[0 1 2]
 [3 4 5]]
writer 0 done
i: 1
a: 1.6179999999999999
b: [2017, 2018]
c: [[1 2 3]
 [4 5 6]]
writer 1 done
i: 2
a: 2.618
b: [2018, 2019]
c: [[2 3 4]
 [5 6 7]]
writer 2 done
i: 3
a: 3.618
b: [2019, 2020]
c: [[3 4 5]
 [6 7 8]]
writer 3 done
i: 4
a: 4.618
b: [2020, 2021]
c: [[4 5 6]
 [7 8 9]]
writer 4 done
Tensor("ParseSingleExample_13/ParseSingleExample:0", shape=(), dtype=float32)
Tensor("ParseSingleExample_13/ParseSingleExample:1", shape=(2,), dtype=int64)
Tensor("Reshape_8:0", shape=(2, 3), dtype=uint8)
====================
first batch:
a_val: [2.618 3.618 3.618]
b_val: [[2018 2019]
 [2019 2020]
 [2019 2020]]
c_val: [[[2 3 4]
  [5 6 7]]

 [[3 4 5]
  [6 7 8]]

 [[3 4 5]
  [6 7 8]]]
second batch:
a_val: [3.618 4.618 1.618]
b_val: [[2019 2020]
 [2020 2021]
 [2017 2018]]
c_val: [[[3 4 5]
  [6 7 8]]

 [[4 5 6]
  [7 8 9]]

 [[1 2 3]
  [4 5 6]]]
```

