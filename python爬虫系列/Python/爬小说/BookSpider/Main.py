# -*- coding: utf-8 -*-
import re
import os
import requests

class fetchBook:
    def __init__(self):
        #浏览器伪装
        self.header = { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0'}
        self.urls = ['http://txt.rain8.com/txtgw/',
                     'http://txt.rain8.com/txtzj/',
                     'http://txt.rain8.com/txtzx/',
                     'http://txt.rain8.com/txtsh/']
        #re库是python专门写正则表达式的库
        self.rePageIndex = re.compile('list_\d+_\d+.html')  # 得到栏目编号
        self.rePageCount = re.compile('<strong>\d+</strong>')  # 得到页面数目
        self.reDownloadGet1 = re.compile('href=.http://txt.rain8.com/plus/xiazai_yfx.php?[^>]+')  # 得到下载链接
        self.reGetTitle = re.compile('<title>.+</title>')  # 得到标题
        self.reGetAuthor = re.compile("</small><span>[^>]+")  # 得到作者名称
        self.reBookGetNew = re.compile('')  # 得到书籍链接
        self.reBookGetOld = re.compile('')
        self.cnt = 0


    def viewAllPage(self,url):
        #所有页面过一遍,req是请求下来的内容
        req = requests.get(url, headers = self.header)
        #findall()后面跟的正则表达式
        pageIndex = self.rePageIndex.findall(req.text)[0][5:7]
        pageCount = int(self.rePageCount.findall(req.text)[0][8:-9])
        urlToFetch = [url, 'list_', pageIndex, '_', '1', '.html']
        foldname = self.reGetTitle.findall(req.text)[0][7:]
        foldname = foldname.encode('unicode_escape').decode('string_escape')
        self.createDir(foldname)
        for page in range(1,pageCount+1):
            urlToFetch[4] = str(page)
            url_to_get = ''.join(urlToFetch)



if __name__ == '__main__':
    obj_spider = fetchBook()























