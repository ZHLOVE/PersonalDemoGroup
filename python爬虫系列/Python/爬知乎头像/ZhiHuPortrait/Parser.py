# -*- coding: utf-8 -*-

import re
import urlparse
from bs4 import BeautifulSoup

class HtmlParser(object):
    def parse(self, page_url, html_cont):
        if page_url is None or html_cont is None:
            return
        soup = BeautifulSoup(html_cont, 'lxml', from_encoding='utf-8')
        new_urls = self._get_new_urls(page_url, soup)
        print new_urls
        new_data = self._get_new_data(page_url, soup)
        return new_urls, new_data

    def _get_new_urls(self, page_url, soup):
        new_urls = set()
        links = soup.find_all('a', href = re.compile(r'/view/\d+\.htm'))
        # print links
        for link in links:
            new_url = link['href']
            # print new_url
            new_full_url = urlparse.urljoin(page_url, new_url)
            new_urls.add(new_full_url)
        return new_urls
    def _get_new_data(self, page_url, soup):
        res_data = {}
        # url
        res_data['url'] = page_url
        # <div class="ProfileAvatarEditor">
        # <img class="Avatar Avatar--l" src="https://pic3.zhimg.com/cdc60a37a_l.jpg" srcset="https://pic3.zhimg.com/cdc60a37a_xl.jpg 2x" alt="马千里">
        # <span class="ProfileAvatarEditor-tip">修改头像</span>
        # <span class="ProfileAvatarEditor-spinner Spinner"></span>
        # </div>

        # <dd class="lemmaWgt-lemmaTitle-title"><h1 >Python</h1>
        # 得到标题的标签h1
        # title_node = soup.find('dd', class_='lemmaWgt-lemmaTitle-title').find('h1')
        touXiang_node = soup.find('div', class_='body clearfix').find('srcset')
        res_data['img'] = touXiang_node.get_text()

        # 内容</dl><div class="lemma-summary" label-module="lemmaSummary">
        summary_node = soup.find('div', class_='lemma-summary')
        res_data['lemma-summary'] = summary_node.get_text()
        return res_data

