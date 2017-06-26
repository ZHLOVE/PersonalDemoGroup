# -*- coding:utf-8 -*-

from lxml import etree
import requests

class WallPaper:
    def __init__(self,baseUrl,index,filePath):
        self.urlStr = baseUrl
        self.index = index
        self.filePath = filePath

    #获取每页所有图片URL
    def getImageUrlListFromPage(self,page):
        selector = etree.HTML(page)
        urlList = selector.xpath(r'//div/span/span[1]/span/a/@href')  # 页面上所有想要的图片的URL
        return urlList

    #获取每页内容
    def getPageFromUrl(self,url):
        page = requests.get(url)
        return page.text

    #获取高清图片URL
    def getHeightImageURLFromURL(self,URL):
        page = self.getPageFromUrl(URL)
        selector = etree.HTML(page)
        gaoQingImageURL = selector.xpath(r'//div/div[4]/div[1]/div[1]/img[2]/@src')
        return gaoQingImageURL[0]

    def saveImageFromUrl(self,gaoQingImgUrl):
        nameList = gaoQingImgUrl.split('dota_2___')
        temp = nameList[1]
        name = temp.split('_')[0] + '.jpg'
        print '正在下载' + name
        image = requests.get(gaoQingImgUrl,timeout = 60)
        print image.status_code
        path = self.filePath + name
        f = open(path,'w')
        f.write(image.content)
        f.close()
        print '已经下载' + name


    #调度程序
    def start(self):
        while(self.index < 4):
            URL = self.urlStr + str((self.index - 1)*24)
            print '第' + str(self.index) + '页'
            page = self.getPageFromUrl(URL)
            urlList = self.getImageUrlListFromPage(page)
            count = 1
            for imageUrl in urlList:
                gaoQingImageURL = self.getHeightImageURLFromURL(imageUrl)
                print '第' + str(count) + '张' +  gaoQingImageURL
                count += 1
                self.saveImageFromUrl(gaoQingImageURL)
            self.index += 1
            count = 1





# offset = (index-1) * 24
filePath = '/Users/mbp/Desktop/桌面壁纸/'
baseUrl = 'http://sheron1030.deviantart.com/gallery/?offset='
wp = WallPaper(baseUrl,1,filePath)
wp.start()


