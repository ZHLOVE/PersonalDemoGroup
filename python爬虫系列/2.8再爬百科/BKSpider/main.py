# -*- coding:utf-8 -*-

import requests


import HTML_download,HTML_Parser,HTML_output,Url_manager

class SpiderMain:
    def __init__(self):
        self.urls = Url_manager.Url_manager()
        self.downloader = HTML_download.HTML_download()
        self.parser = HTML_Parser.HTML_Parser()
        self.output = HTML_output.HTML_output()


    #爬虫的调度
    def craw(self,root_url):
        count = 1
        self.urls.addNewUrl(root_url)
        try:
            while self.urls.hasNewUrls():
                newUrl = self.urls.getNewUrls() #新的URL
                print '爬第' + str(count) + '个'
                htmlCont = self.downloader.download(newUrl) #下载好的页面
                newUrls, newData = self.parser.parser(newUrl,htmlCont)
                self.urls.addNewUrls(newUrls)
                self.output.collectData()

                if count == 1000:
                    break

                count += 1
        except requests.exceptions.HTTPError as err:
            print err

        self.output.saveData()






root_url = 'http://baike.baidu.com/view/1219.htm'
spider = SpiderMain()

spider.craw(root_url)