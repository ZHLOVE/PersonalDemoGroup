# -*- coding:utf-8 -*-

import urllib
import urllib2
import re

page = 1
url = 'http://www.qiushibaike.com/8hr/page/' + str(page) + '/'
userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36'
headers = {'User-Agent':userAgent}
try:
    print url
    request = urllib2.Request(url=url,headers=headers)
    response = urllib2.urlopen(request)
    content = response.read().decode('utf-8')
    # pattern = re.compile('<div.*?author">.*?<a.*?<img.*?>(.*?)</a>.*?<div.*?' + 'content">(.*?)<!--(.*?)-->.*?</div>(.*?)<div class="stats.*?class="number">(.*?)</i>',re.S)
    # 现在正则表达式在这里稍作说明
    # 1）.*? 是一个固定的搭配，.和*代表可以匹配任意无限多个字符，加上？表示使用非贪婪模式进行匹配，也就是我们会尽可能短地做匹配，以后我们还会大量用到 .*? 的搭配。
    # 2）(.*?)代表一个分组，在这个正则表达式中我们匹配了五个分组，在后面的遍历item中，item[0]就代表第一个(.*?)所指代的内容，item[1]就代表第二个(.*?)所指代的内容，以此类推。
    # 3）re.S 标志代表在匹配时为点任意匹配模式，点 . 也可以代表换行符。
    pattern2 = re.compile('<div class="author clearfix">.*?<h2>(.*?)</h2>.*?"content">(.*?)</div>.*?number">(.*?)</.*?number">(.*?)</.',re.S)
    items = re.findall(pattern=pattern2, string=content)
    for item in items:
        haveImg = re.search("img", item[3])
        if not haveImg:
            print item[0],item[1]
except urllib2.URLError, e:
    if hasattr(e,"code"):
        print e.code
    if hasattr(e,"reason"):
        print e.reason

