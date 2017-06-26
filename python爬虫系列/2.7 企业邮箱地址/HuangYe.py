# -*- coding:utf-8 -*-


import requests
from lxml import etree
import csv


class HuangYe:
    def __init__(self,base):
        self.base = base
        self.session = requests.Session()
        self.huangYeUrl = base


    # 获取无锡企业名录urls
    def getWuXiQiYeMingLuUrl(self):
        url = self.base
        page = self.session.get(url,timeout = 60)
        selector = etree.HTML(page.text)
        list0 = selector.xpath(r'//*[@id="subcatlisting_10"]/ul/li/a/@href')
        list1 = selector.xpath(r'//*[@id="subcatlisting_11"]/ul/li/a/@href')
        list2 = selector.xpath(r'//*[@id="subcatlisting_12"]/ul/li/a/@href')
        list3 = selector.xpath(r'//*[@id="subcatlisting_13"]/ul/li/a/@href')
        list4 = selector.xpath(r'//*[@id="subcatlisting_14"]/ul/li/a/@href')
        lists = (list0,list1,list2,list3,list4)
        mingLuLists = []
        for list in lists:
            for name in list:
                mingLuLists.append(name)
        # print mingLuLists
        return mingLuLists

    def getPageFromUrl(self,url):
        for i in xrange(10):
            try:
                page = requests.get(url,timeout = 60)
                return page.text
            except requests.exceptions.Timeout as e:
                print e



    # 判断是否是最后一页
    def judgeLastPage(self,page):
        selector = etree.HTML(page)
        lastText = selector.xpath(r'/html/body/div/div/div/div/div[3]/a')
        lastUrl = selector.xpath(r'/html/body/div/div/div/div/div[3]/a/@href')
        tempText = lastText[-3:]
        text = []
        url = lastUrl[-3:]
        str = u'下一页'
        #
        for i in range(len(tempText)):
           text.append(tempText[i].text)
        if str in text:
            return u'  '
        else:
            print '已经是最后一页'
            return 0

    def getNextPageUrl(self,page):
        selector = etree.HTML(page.text)
        lastText = selector.xpath(r'/html/body/div/div/div/div/div[3]/a')
        lastUrl = selector.xpath(r'/html/body/div/div/div/div/div[3]/a/@href')
        tempText = lastText[-3:]
        text = []
        url = lastUrl[-3:]
        for i in range(len(tempText)):
           text.append(tempText[i].text)
        if str in text:
            index =  text.index(str)
            nextUrl = url[index]
            return nextUrl


    def getWuXiMingLuCompanyInfoFromUrl(self,url):
        for i in xrange(10):
            try:
                page = self.getPageFromUrl(url,timeout = 60)
                selecotr = etree.HTML(page.text)
                companyNames = selecotr.xpath(r'//dl/dt/h4/a')
                companyUrls = selecotr.xpath(r'//dl/dt/h4/a/@href')
                companyPhone = selecotr.xpath(r'//*[@id="jubao"]/dl/dt/span/a')
                for i in xrange(len(companyNames)):
                    name = companyNames[i].text
                    url = companyUrls[i]
                    phone = companyPhone[i].text
                    print name + ' ' + url + ' ' + phone
                    companyInfo = (name,url,phone)
                    return companyInfo
            except requests.exceptions.Timeout as e:
                 print e


    # def openCSV(self):
    #     csvfile = open('csv_test.csv', 'w', newline='')
    #     writer = csv.writer(csvfile, delimiter=' ', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    #     writer.writerow(['公司', '网址', '电话'])
    #     csvfile.close()

    def saveToCSV(self,companyInfo):
        c = open("url.csv", "wa")
        c.write('\xEF\xBB\xBF')
        writer = csv.writer(c)
        writer.writerow(companyInfo)
        c.close()






    def getCompanyUrls(self):
        classList = self.getWuXiQiYeMingLuUrl()
        companyUrls = []
        for classUrl in classList:
            for i in xrange(1,1000):
                try:
                    pageUrl = classUrl + 'pn' + str(i) + '/'
                    webPage = self.getPageFromUrl(pageUrl)
                    result = self.judgeLastPage(webPage)
                    print '网址:' + pageUrl
                    print result + '\n'
                    companyUrls.append(pageUrl)
                except:
                    break
        return companyUrls