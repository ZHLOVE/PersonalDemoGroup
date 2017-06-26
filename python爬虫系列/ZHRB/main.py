# -*- coding:utf-8 -*-
import urllib2
import requests
import cookielib
from bs4 import  BeautifulSoup

from lxml import etree

url = 'https://zhuanlan.zhihu.com/p/20237605?refer=daily'

headers = {'Accept-Language':'zh-CN,zh;q=0.8,id;q=0.6,zh-TW;q=0.4,en;q=0.2','User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36'}


page = requests.get(url,headers=headers)
page.encoding = 'utf-8'

print page.status_code

selector = etree.HTML(page.text)
titleArray = selector.xpath(r'/html/body/main/div[1]/article/header/div[1]/img/@src')
print page.text
print titleArray