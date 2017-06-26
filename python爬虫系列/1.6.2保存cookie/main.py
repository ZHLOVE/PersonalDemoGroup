# -*- coding:utf-8 -*-

import urllib2
import cookielib
import urllib
import json
# 将cookie保存到文件
# 设置保存cookie的文件,同级目录下的cookie.txt
filename = 'cookie.txt'
# 声明一个MozillaCookieJar对象实例来保存cookie,之后写入文件
cookie = cookielib.MozillaCookieJar(filename)
# 创建cookie处理器
handler = urllib2.HTTPCookieProcessor(cookie)
# 构建opener
opener = urllib2.build_opener(handler)
# 创建请求
urlStr = "https://www.douban.com/accounts/login"
postData = urllib.urlencode({'form_email':'18505101236','form_password':'mql50880640'})
response = opener.open(urlStr,data=postData)
# info = response.read()
# dict = json.loads(info)
# for key in dict:
#     print  dict[key]
print response.read()

# 保存cookie到文件
cookie.save(ignore_discard=True, ignore_expires=True)

