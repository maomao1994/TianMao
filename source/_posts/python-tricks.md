---
title: python tricks
date: 2018-09-05 14:58:38
tags: tricks
categories: python
keywords : python tricks
---

## python使用相关的技巧

<!--more-->

- 模块路径（在命令行下，只能识别到当前的路径）
```python
import sys
sys.path.append("项目的绝对路径")
```


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
- 从字符串加载字典
```
>>> import ast
>>> user = '{"name" : "john", "gender" : "male", "age": 28}'
>>> user_dict = ast.literal_eval(user)
>>> user_dict
{'gender': 'male', 'age': 28, 'name': 'john'}
user_info = "{'name' : 'john', 'gender' : 'male', 'age': 28}"
>>> user_dict = ast.literal_eval(user)
>>> user_dict
{'gender': 'male', 'age': 28, 'name': 'john'}
```

- 常用的标点符号
```
puncts = [',', '.', '"', ':', ')', '(', '-', '!', '?', '|', ';', "'", '$', '&', '/', '[', ']', '>', '%', '=', '#', '*', '+', '\\', '•',  '~', '@', '£', 
 '·', '_', '{', '}', '©', '^', '®', '`',  '<', '→', '°', '€', '™', '›',  '♥', '←', '×', '§', '″', '′', 'Â', '█', '½', 'à', '…', 
 '“', '★', '”', '–', '●', 'â', '►', '−', '¢', '²', '¬', '░', '¶', '↑', '±', '¿', '▾', '═', '¦', '║', '―', '¥', '▓', '—', '‹', '─', 
 '▒', '：', '¼', '⊕', '▼', '▪', '†', '■', '’', '▀', '¨', '▄', '♫', '☆', 'é', '¯', '♦', '¤', '▲', 'è', '¸', '¾', 'Ã', '⋅', '‘', '∞', 
 '∙', '）', '↓', '、', '│', '（', '»', '，', '♪', '╩', '╚', '³', '・', '╦', '╣', '╔', '╗', '▬', '❤', 'ï', 'Ø', '¹', '≤', '‡', '√', ]
```

- 远程使用服务器的jupyter notebook

```sh
jupyter notebook --no-browser --port=8889

# you should leave the this open
ssh -N -f -L localhost:8888:localhost:8889 username@your_remote_host_name

# make sure to change `username` to your real username in remote host
# change `your_remote_host_name` to your address of your working station
# Example: ssh -N -f -L localhost:8888:localhost:8889 laura@cs.rutgers.edu
```



- pip 导出依赖包

```sh
# 切换环境
source activate tensorflow
# 到处依赖
pip freeze > tesorflow.requires
```

结果如下：

```
absl-py==0.6.1
astor==0.7.1
atomicwrites==1.2.1
attrs==18.2.0
backcall==0.1.0
beautifulsoup4==4.7.1
bs4==0.0.1
certifi==2018.10.15
chardet==3.0.4
Click==7.0
colorama==0.4.1
cycler==0.10.0
decorator==4.3.0
filelock==3.0.10
flatbuffers==1.10
funcsigs==1.0.2
gast==0.2.0
graphviz==0.10.1
grpcio==1.16.1
h5py==2.8.0
hyperlpr==0.0.1
idna==2.8
imageio==2.5.0
ipykernel==5.1.0
ipython==7.1.1
ipython-genutils==0.2.0
jedi==0.13.1
joblib==0.13.0
jupyter-client==5.2.3
jupyter-core==4.4.0
Keras==2.2.4
Keras-Applications==1.0.6
Keras-Preprocessing==1.0.5
kiwisolver==1.0.1
langdetect==1.0.7
lightgbm==2.2.3
lxml==4.3.2
Markdown==3.0.1
matplotlib==3.0.2
more-itertools==5.0.0
networkx==2.3
nltk==3.4
numpy==1.15.4
opencv-python==4.1.0.25
pandas==0.23.4
parso==0.3.1
pexpect==4.6.0
pickleshare==0.7.5
Pillow==5.3.0
pluggy==0.8.0
prompt-toolkit==2.0.7
protobuf==3.6.1
ptyprocess==0.6.0
py==1.7.0
pycryptodomex==3.6.6
Pygments==2.2.0
pyparsing==2.3.0
pytest==4.1.0
python-dateutil==2.7.5
pytz==2018.5
PyWavelets==1.0.3
PyYAML==3.13
pyzmq==17.1.2
ray==0.6.1
redis==2.10.6
redis-py-cluster==1.3.6
requests==2.21.0
scapy==2.4.0
scapy-ssl-tls==2.0.0
scikit-image==0.15.0
scikit-learn==0.20.0
scipy==1.1.0
seaborn==0.9.0
singledispatch==3.4.0.3
six==1.11.0
sklearn==0.0
soupsieve==1.8
tensorboard==1.12.0
tensorflow==1.12.0
termcolor==1.1.0
tinyec==0.3.1
tornado==5.1.1
tqdm==4.28.1
traitlets==4.3.2
urllib3==1.24.1
wcwidth==0.1.7
Werkzeug==0.14.1
xgboost==0.81
xmltodict==0.12.0
```

