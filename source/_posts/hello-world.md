---
title: Hello World
---
Welcome to [Hexo](https://hexo.io/)! This is your very first post. Check [documentation](https://hexo.io/docs/) for more info. If you get any problems when using Hexo, you can find the answer in [troubleshooting](https://hexo.io/docs/troubleshooting.html) or you can ask me on [GitHub](https://github.com/hexojs/hexo/issues).

## Quick Start

## 安装和使用
```
$ npm install -g hexo-cli
$ hexo init <folder> #我的是blog#
$ cd <folder>
$ npm install
# 安装 hexo-deployer-git
$ npm install hexo-deployer-git --save
$ hexo clean
$ hexo g
$ hexo d
```

### Create a new post

``` bash
$ hexo new "My New Post"
```

More info: [Writing](https://hexo.io/docs/writing.html)

### Run server

``` bash
$ hexo server
```

More info: [Server](https://hexo.io/docs/server.html)

### Generate static files

``` bash
$ hexo generate
```

More info: [Generating](https://hexo.io/docs/generating.html)

### Deploy to remote sites

``` bash
$ hexo deploy
```
### 上传图片
```
1 把主页配置文件_config.yml 里的post_asset_folder:这个选项设置为true

2 在你的hexo目录下执行这样一句话npm install hexo-asset-image --save
```
### 示例
```
title: Linux权能与PAM机制
date: 2018-05-01 08:09:12
updated: 2018-05-01 08:09:12
tags:
 Linux
 capability
categories: Linux
copyright: true
```

More info: [Deployment](https://hexo.io/docs/deployment.html)
