# -*- coding:utf-8 -*-

from lxml import etree
import requests


class HTML_Parser:

    def parser(self,pageUrl,pageData):
        if pageUrl is None or pageData is None:
            return  None
        selector = etree.HTML(pageData)
        newlist = selector.xpath(r'//*[@class="para"]/*[@target="_blank"]/@href')
        dataList = selector.xpath(r'//*[@class="para"]/*[@target="_blank"]')
        newUrls = set()
        newPageData = set()

        for i in xrange(len(newlist)):
            Url = 'http://baike.baidu.com' + newlist[i]
            data = dataList[i]
            print Url
            print data.text
            newUrls.add(Url)

        # print newUrls
        # print dataList

        return newUrls,dataList
