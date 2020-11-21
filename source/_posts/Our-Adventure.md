---
title: Our Adventure
date: 2020-08-19 22:49:26
tags: 平&茂
categories: 平&茂
---

2020年8月1日，第一次在长沙见到平平。

2020年10月4日（八月十八，我的生日），平平和我在一起了。

<!--more-->

<script type="text/javascript">
function getValue()
  {
    var dateBegin = new Date("2020-08-01 00:00:00");//将-转化为/，使用new Date
    var dateEnd = new Date();//获取当前时间
    var dateDiff = dateEnd.getTime() - dateBegin.getTime();//时间差的毫秒数
    var dayDiff = Math.floor(dateDiff / (24 * 3600 * 1000));//计算出相差天数
    var leave1=dateDiff%(24*3600*1000) //计算天数后剩余的毫秒数
    var hours=Math.floor(leave1/(3600*1000))//计算出小时数
    //计算相差分钟数
    var leave2=leave1%(3600*1000) //计算小时数后剩余的毫秒数
    var minutes=Math.floor(leave2/(60*1000))//计算相差分钟数
    //计算相差秒数
    var leave3=leave2%(60*1000) //计算分钟数后剩余的毫秒数
    var seconds=Math.round(leave3/1000)
  	var x=document.getElementById("myHeader")
    x.innerHTML="我们认识的:"+dayDiff+"天 "+hours+"小时 "+minutes+" 分钟"+seconds+" 秒"
  	alert(x.innerHTML)
  }
</script>

我们认识了多久？<a id="myHeader" onclick="getValue()">点我看看</a>