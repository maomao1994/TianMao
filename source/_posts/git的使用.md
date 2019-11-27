---
title: git的使用
date: 2019-11-27 11:32:30
tags: git
categories: tips
---

记录git的日常用法，附加github的使用技巧。

<!--more-->

- 忽略push的文件

```sh
# 编写gitignore文件，注意项目路径的写法，不要使用“./文件夹”表示从当前开始，直接就是“文件夹即可”
git rm -r --cached .
git add .
git commit -m 'update .gitignore'
```

