---
title: ensemble之初音女神
date: 2018-12-15 14:24:13
tags: 机器学习
categories: machine learning
---

通过初音案例分析ensemble原理

<!--more-->

#  一.初音


```python
import matplotlib
import numpy as np
from PIL import Image
from matplotlib.pyplot import imshow
```


```python
miku = pd.read_csv("../data/miku")
miku = np.array(miku.values)

miku_grayscale = miku[:, 2]

miku_grayscale = miku_grayscale.reshape((500, 500))
miku_grayscale = miku_grayscale.transpose()

image = Image.fromarray(miku_grayscale*255)
print(image.size)
imshow(image)
# image.show()
# np.random.shuffle(miku)
miku_data = miku[:, 0:2]
miku_target = miku[:, 2]
```

    (500, 500)



![png](ensemble之初音女神/output_2_1.png)


# 二.Decision Tree


```python
from sklearn.tree import DecisionTreeClassifier
clf = DecisionTreeClassifier()
clf.fit(miku_data, miku_target)
predict = clf1.predict(miku_data)
predict = predict.reshape((500, 500))
predict = predict.transpose()

image_pre = Image.fromarray(predict*255)
# image_pre.show()
imshow(image_pre)
```




    <matplotlib.image.AxesImage at 0x7f9d75154be0>




![png](ensemble之初音女神/output_4_1.png)


# 三.Bagging


```python
# bagging
from sklearn.ensemble import BaggingClassifier
from sklearn.tree import DecisionTreeClassifier
# clf = BaggingClassifier(DecisionTreeClassifier(max_depth=5), n_estimators=100)
clf = BaggingClassifier(DecisionTreeClassifier(), n_estimators=100)

clf.fit(miku_data, miku_target)

predict = clf.predict(miku_data)
predict = predict.reshape((500, 500))
predict = predict.transpose()

image_pre = Image.fromarray(predict*255)
# image_pre.show()
imshow(image_pre)
```




    <matplotlib.image.AxesImage at 0x7f9d71a9e7b8>




![png](ensemble之初音女神/output_6_1.png)


# 四.Boosting


```python
# adaboost
from sklearn.ensemble import AdaBoostClassifier
from sklearn.tree import DecisionTreeClassifier
clf1 = AdaBoostClassifier(DecisionTreeClassifier(max_depth=5), n_estimators=10)


clf1.fit(miku_data, miku_target)

predict1 = clf1.predict(miku_data)
predict1 = predict1.reshape((500, 500))
predict1 = predict1.transpose()

image_pre1 = Image.fromarray(predict1*255)
# image_pre.show()
imshow(image_pre1)
```




    <matplotlib.image.AxesImage at 0x7f9d75653278>




![png](ensemble之初音女神/output_8_1.png)



```python
clf2 = AdaBoostClassifier(DecisionTreeClassifier(max_depth=5), n_estimators=100)
clf2.fit(miku_data, miku_target)
predict2 = clf2.predict(miku_data)
predict2 = predict2.reshape((500, 500))
predict2 = predict2.transpose()
image_pre2 = Image.fromarray(predict2*255)
imshow(image_pre2)
```




    <matplotlib.image.AxesImage at 0x7f9d75623630>




![png](ensemble之初音女神/output_9_1.png)


# 五.GBDT


```python
from sklearn.ensemble import GradientBoostingClassifier
clf3 = GradientBoostingClassifier(max_depth=10,n_estimators=100)
clf3.fit(miku_data, miku_target)
predict4 = clf3.predict(miku_data)
predict4 = predict4.reshape((500, 500))
predict4 = predict4.transpose()

image_pre4 = Image.fromarray(predict4*255)
# image_pre.show()
imshow(image_pre4)
```




    <matplotlib.image.AxesImage at 0x7f9d7517fac8>




![png](ensemble之初音女神/output_11_1.png)


# 六.XGBoost


```python
import xgboost as xgb
param = {'max_depth':5, 
         'eta':1, 
         'silent':1, 
         'objective':'binary:logistic',
         'n_estimators':10,
        }
num_rounds = 500 # 迭代次数
xgb_train=xgb.DMatrix(miku_data,label=miku_target)
xgb_test=xgb.DMatrix(miku_data)

model = xgb.train(param, xgb_train, num_rounds)

predict3=model.predict(xgb_test)
predict3 = predict3.reshape((500, 500))
predict3 = predict3.transpose()
image_pre3 = Image.fromarray(predict3*255)
imshow(image_pre3)
```




    <matplotlib.image.AxesImage at 0x7f9d752e9518>




![png](ensemble之初音女神/output_13_1.png)

