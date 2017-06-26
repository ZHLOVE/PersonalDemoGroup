# -*- coding:utf-8 -*-

import urllib
import urllib2
import os
from lxml import etree

class TBMM:
    def __init__(self,baseUrl):
        self.siteUrl = baseUrl

    def getPage(self,pageIndex):
        url = self.siteUrl + '?' + 'page=' + str(pageIndex)
        request = urllib2.Request(url)
        response = urllib2.urlopen(request)
        # print response.read().decode('gbk')
        return response.read().decode('gbk')

    def getContent(self,pageIndex):

        page = self.getPage(pageIndex)
        selector = etree.HTML(page)
        names = selector.xpath(r'//div/p/a/text()') #名字

        jiFen = selector.xpath(r'/html/body/div/div[2]/div[1]/dl/dd/text()') #积分
        jiFenList = list()
        for str in jiFen:
            x = (str.lstrip()).rstrip()
            jiFenList.append(x)
        while '' in jiFenList:
            jiFenList.remove('')


        imagePath = selector.xpath('/html/body/div/div[1]/div[1]/div/a/img/@src') #人物图片
        imagePathList = list()
        for str in imagePath:
            url = 'https:' + str
            imagePathList.append(url)
        print names
        print jiFenList
        print imagePathList
        for index in range(len(names)):
            name =  names[index].encode('utf-8')
            url =  imagePathList[index]
            self.saveImage('/Users/mbp/Desktop/爬虫入门系列/2.2爬淘宝MM图片/' + name + '.jpg', url)

    def saveImage(self,path,imageURL):
        u = urllib.urlopen(imageURL)
        data = u.read()
        file = open(path,'wb')
        file.write(data)
        file.close()




# https://mm.taobao.com/json/request_top_list.htm?page=1
baseUrl = 'https://mm.taobao.com/json/request_top_list.htm'
 tbmm.getContent(1)
tbmm.saveImage('/Users/mbp/Desktop/爬虫入门系列/2.2爬淘宝MM图片' + '/' + '圆圆' + '.jpg', 'https://gtd.alicdn.com/sns_logo/i6/TB1EjxDKXXXXXXhaXXXSutbFXXX.jpg_60x60.jpg')
