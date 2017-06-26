# -*- coding:utf-8 -*-

import urllib
import urllib2
import cookielib

# 获得cookie
# 声明一个cookieJar对象来实例来保存cookie
cookie = cookielib.CookieJar()
# 利用urllib2库的HTTPCookieProcessor对象来创建cookie处理器
handler = urllib2.HTTPCookieProcessor(cookie)
# 通过handler来构建opener
opener = urllib2.build_opener(handler)
# 此处的open方法同urllib2的urlopen方法,也可以传入request
response = opener.open('https://www.zhihu.com/')
print response.read()

