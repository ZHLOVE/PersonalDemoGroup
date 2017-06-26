# -*- coding:utf-8 -*-

import urllib
import urllib2
import re
import thread
import time

# 糗百爬虫
class QSBK:
    def __init__(self):
        self.pageIndex = 1
        self.userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36'
        #初始化headers
        self.headers = {'User-Agent':self.userAgent}
        #存放段子的数组,每个元素是每一页的段子们
        self.stories = []
        #存放程序是否继续运行的变量
        #存放程序是否可以继续执行的变量
        self.enable = False


    def getPage(self,pageIndex):
        try:
            url = 'http://www.qiushibaike.com/8hr/page/' + str(pageIndex) + '/'
            #构建请求的request
            request = urllib2.Request(url=url,headers=self.headers)
            #利用urlOpen获取页面代码
            response = urllib2.urlopen(request)
            #将页面转化为UTF-8
            pageCode = response.read().decode('utf-8')
            return pageCode
        except urllib2.URLError,e:
            if hasattr(e,"reason"):
                print u"网络错误",e.reason
                return None

    def getPageItems(self,pageIndex):
        pageCode = self.getPage(pageIndex)
        if not pageCode:
                print "页面加载失败..."
                return None
        pattern = re.compile('<div class="author clearfix">.*?<h2>(.*?)</h2>.*?"content">(.*?)</div>.*?number">(.*?)</.*?number">(.*?)</.',re.S)
        items = re.findall(pattern, pageCode)
        #用来存储每页的段子们
        pageStories = []
        #遍历正则表达式匹配的信息
        for item in items:
            #是否含有图片
            haveImg = re.search("img",item[3])
            #如果不含图片就加入list中  re.sub正则替换
            if not haveImg:
                replaceBR = re.compile('<br/>')
                text = re.sub(replaceBR,"\n",item[1])
                #item[0]是一个段子的发布者,item[1]是内容
                pageStories.append([item[0].strip(),text.strip(),item[1].strip()])
        return pageStories

    #加载并获取页面的内容,加入到列表中
    def loadPage(self):
        #如果当前未看的页数少于2页,则加载新一页
        if self.enable == True:
            if len(self.stories)<2:
                #获取新的一页
                newPageStories = self.getPageItems(self.pageIndex)
                #将该页的段子存放到全局List中
                if newPageStories:
                    self.stories.append(newPageStories)
                    #获取完后页码索引加1
                    self.pageIndex += 1

    #每次敲一次回车输出一个段子
    def getOneStory(self,pageStories,page):
        #遍历一页的段子
        for story in pageStories:
            #等待用户输入
            input = raw_input()
            #每当输入回车一次,判断一下是否要加载新页面
            self.loadPage()
            #如果输入Q则程序结束
            if input == "Q":
                self.enable = False
                return
            print u"第%d页\t发布者:%s\n%s" %(page,story[0],story[1])

    #开始方法
    def start(self):
        print "start"
        self.enable = True
        #先加载一页内容
        self.loadPage()
        #局部变量,控制当前读到了第几页
        nowPage = 0
        while self.enable:
            if len(self.stories) > 0:
                pageStories = self.stories[0]
                nowPage += 1
                del self.stories[0]
                self.getOneStory(pageStories, nowPage)

spider = QSBK()
spider.start()
