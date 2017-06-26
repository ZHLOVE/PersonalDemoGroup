# -*- coding:utf-8 -*-


class Url_manager:
    def __init__(self):
        #待维护的新旧两个Urls表
        self.newUrls = set()
        self.oldUrls = set()

    def addNewUrl(self,url):
        if url is None:
            return
        if url not in self.oldUrls and url not in self.newUrls:
            self.newUrls.add(url)

    def addNewUrls(self,urls):
        if urls is None and len(urls) == 0:
            return
        for url in urls:
            self.addNewUrl(url)

    def hasNewUrls(self):
        return len(self.newUrls) != 0

    def getNewUrls(self):
        #pop会从newUrls中取一个url出来并从newurls中移除
        newUrl = self.newUrls.pop()
        self.oldUrls.add(newUrl)
        return newUrl

