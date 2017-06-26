# -*- coding:utf-8 -*-

import urllib
import urllib2
import re

__author__ = 'CQC'



#百度贴吧爬虫Demo
# http://tieba.baidu.com/p/3138733512?see_lz=1&pn=1
class BDTB:
    def __init__(self,baseUrl,seeLZ):
        # url地址
        self.baseUrl = baseUrl
        # 是否只看楼主
        self.seeLZ = '?see_lz='+str(seeLZ)
        # 过滤工具
        self.tool = Tool()
        # 楼层编号
        self.floor = 1
        self.floorTag = 1


    def getPage(self,page):
        try:
            url = self.baseUrl + self.seeLZ +'&pn=' +str(page)
            request = urllib2.Request(url)
            response = urllib2.urlopen(request)
            # print response.read().decode('utf-8') #测试输出
            return response.read().decode('utf-8')

        except urllib2.URLError,e:
            if hasattr(e, "reason"):
                print u"网络错误", e.reason
                return None

    def getTitle(self,page):
        # 得到标题的正则表达式
        pattern = re.compile('<h3 class="core_title_txt.*?>(.*?)</h3>',re.S)
        result = re.search(pattern,page)
        if result:
            print result.group(1)  #测试输出
            return result.group(1).strip()
        else:
            return None

    def getPageNum(self,page):
        #获取帖子一共有多少页
        pattern = re.compile('<li class="l_reply_num.*?</span>.*?>(.*?)</span>.*?</li>',re.S)
        result = re.search(pattern,page)
        if result:
            # print result.group(0) #测试输出
            return result.group(1).strip()
        else:
            return None

    def getContent(self,page):
        #获取帖子正文
        pattern = re.compile('<div id="post_content_.*?class="d_post_content.*?>(.*?)</div>',re.S)
        result = re.findall(pattern,page)
        contents = []
        for item in result:
            # 将文本进行去除标签处理，同时在前后加入换行符
            content = "\n" + self.tool.replace(item) + "\n"
            contents.append(content.encode('utf-8'))
        return contents


    def setFileTitle(self, title):
        # 如果标题不是为None，即成功获取到标题
        if title is not None:
            self.file = open(title + ".txt", "w+")
        else:
            self.file = open(self.defaultTitle + ".txt", "w+")


    def writeData(self, contents):
        # 向文件写入每一楼的信息
        for item in contents:
            if self.floorTag == '1':
                # 楼之间的分隔符
                floorLine = "\n" + str(self.floor) + u"---------------------------------------------------------\n"
                self.file.write(floorLine)
            self.file.write(item)
            self.floor += 1

    def start(self):
        page = self.getPage(1)
        pageIndex = self.getPageNum(page)
        title = self.getTitle(page)
        self.setFileTitle(title)
        if pageIndex == None:
            print "URL已失效，请重试"
            return
        try:
            print "该帖子共有" + str(pageIndex) + "页"
            for i in range(1, int(pageIndex) + 1):
                print "正在写入第" + str(i) + "页数据"
                page = self.getPage(i)
                contents = self.getContent(page)
                self.writeData(contents)
        except IOError, e:
            print "写入异常，原因" + e.message
        finally:
            print "写入任务完成"




class Tool:
    # 去除img标签,7位长空格
    removeImg = re.compile('<img.*?>| {7}|')
    # 删除超链接标签
    removeAddr = re.compile('<a.*?>|</a>')
    # 把换行的标签换为\n
    replaceLine = re.compile('<tr>|<div>|</div>|</p>')
    # 将表格制表<td>替换为\t
    replaceTD = re.compile('<td>')
    # 把段落开头换为\n加空两格
    replacePara = re.compile('<p.*?>')
    # 将换行符或双换行符替换为\n
    replaceBR = re.compile('<br><br>|<br>')
    # 将其余标签剔除
    removeExtraTag = re.compile('<.*?>')

    def replace(self, x):
        x = re.sub(self.removeImg, "", x)
        x = re.sub(self.removeAddr, "", x)
        x = re.sub(self.replaceLine, "\n", x)
        x = re.sub(self.replaceTD, "\t", x)
        x = re.sub(self.replacePara, "\n    ", x)
        x = re.sub(self.replaceBR, "\n", x)
        x = re.sub(self.removeExtraTag, "", x)
        # strip()将前后多余内容删除
        return x.strip()



baseURL = 'http://tieba.baidu.com/p/615059004'
# baseURL = 'http://tieba.baidu.com/p/3138733512'
bdtb = BDTB(baseURL,0)
bdtb.start()
