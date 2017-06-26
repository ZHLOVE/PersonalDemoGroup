# -*- coding: utf-8 -*-
import Manager, Parser, Downloader, Outputer
class SpiderMain(object):
    def __init__(self):
        self.urls = Manager.UrlManager()
        self.downloader = Downloader.HtmlDownloader()
        self.parser = Parser.HtmlParser()
        self.outputer = Outputer.HtmlOutputer()

        # 爬虫调度程序
    def craw(self, root_url):
            # count用来记录当前爬取的第几个
            count = 1
            self.urls.add_new_url(root_url)
            # 爬虫循环,当url管理器中有url
            while self.urls.has_new_url():
                # try:
                    # 获取到新的url,get_new_url会自动筛选
                    new_url = self.urls.get_new_url()
                    print 'craw %d: %s' % (count, new_url)
                    # 结果存在html_cont
                    html_cont = self.downloader.download(new_url)
                    # 解析器中解析url页面中包含的其他urls
                    new_urls, new_data = self.parser.parse(new_url, html_cont)
                    # 像url管理器中添加新的urls
                    self.urls.add_new_urls(new_urls)
                    self.outputer.collect_data(new_data)
                    # if count == 300:
                    #     break

                    count = count + 1
                # except:
                    # print 'url 爬取失败'
            self.outputer.output_html()



if __name__ == '__main__':
    root_url = 'https://www.zhihu.com/people/maqianli11'
    obj_spider = SpiderMain()
    obj_spider.craw(root_url)

