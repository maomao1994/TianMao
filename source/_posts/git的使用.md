---
title: git的使用
date: 2019-11-27 11:32:30
tags: git
categories: tips
---

记录git的日常用法，附加github的使用技巧。

<!--more-->

## 忽略push的文件

```sh
# 编写gitignore文件，注意项目路径的写法，不要使用“./文件夹”表示从当前开始，直接就是“文件夹即可”
git rm -r --cached .
git add .
git commit -m 'update .gitignore'
```

## 分支相关

### 创建并切换到新分支

```sh
git checkout -b panda
```

### 查看本地分支

```sh
git branch
```

### 查看分支结构图

```sh
git log --graph 
git log --decorate 
git log --oneline 
git log --simplify-by-decoration 
git log --all
git log --help
```



### 将develop分支merge到master分支

```sh
git add .
git commit -m ''
git push
git checkout master
# checkout不成功可能需要执行git stash命令
git merge develop //将develop 分支与master分支合并
git push //将合并的本地master分支推送到远程master
```

