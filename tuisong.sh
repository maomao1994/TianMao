#!/bin/bash
hexo clean
hexo g | grep html > urls.txt
sed -i 's/INFO  Generated: /www.damaoguo.site\//' urls.txt
curl -H 'Content-Type:text/plain' --data-binary @urls.txt "http://data.zz.baidu.com/urls?site=www.damaoguo.site&token=yskVXZzwGg7ZNWcK"
