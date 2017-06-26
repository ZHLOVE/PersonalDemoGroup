# -*- coding: utf-8 -*-
import requests


class SpiderMain(object):
    def __init__(self):
        header = { 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36'}
        html = requests.get('http://baike.baidu.com/view/21087.htm', header)
        html.encoding = 'utf-8'


if __name__ == '__main__':
    obj_spider = SpiderMain()
