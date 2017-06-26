# -*- coding:utf-8 -*-


import csv

import requests
from lxml import etree

class SpiderJAV:
    def __init__(self,baseUrl,filePath):
        self.baseUrl = baseUrl
        self.filePath = filePath
        self.session = requests.Session()

    def getAllNameFromPage(self,prefix):
        # 根据首字母排列
        allNamesUrl = self.baseUrl + 'star_list.php?prefix=' + prefix
        try:
            webPage = self.session.get(allNamesUrl, timeout=60)
            selector = etree.HTML(webPage.text)
            nameUrlList = selector.xpath(r'//div/div/div/div/a/@href')  # 演员url
            # nameList = selector.xpath(r'//div/div/div/div/a')  # 演员名字
            # print webPage.status_code
            return nameUrlList
        except requests.exceptions.RequestException as e:
            print e
            # sys.exit(1)


    def getMovieListFromName(self,nameUrl):
        pageURL = self.baseUrl + nameUrl
        # print pageURL
        try:
            webPage = self.session.get(pageURL,timeout = 180)
            selector = etree.HTML(webPage.text)
            movieUrlList = selector.xpath(r'//div/div[*]/div/div/div/a/@href') #影片url
            # movieNameList = selector.xpath('//div/div/div/a/@title') #影片名字
            # print webPage.status_code
            return movieUrlList
        except requests.exceptions.RequestException as e:
            print e



base = 'http://www.j9lib.com/cn/'
# http://www.j9lib.com/cn/vl_star.php?&mode=&s=azccm&page=1
filePath = '/Users/mbp/Desktop/JA'
spider = SpiderJAV(base,filePath)
nameUrlList = spider.getAllNameFromPage('A')
for nameUrl in nameUrlList:
    name = nameUrl.split('?')[1]
    print '演员' + name
    pageIndex = 1
    n = 'vl_star.php?&mode=&' + name + '&page=' + str(pageIndex)
    movieUrlList = spider.getMovieListFromName(n)
    if len(movieUrlList) >0 :
        print movieUrlList