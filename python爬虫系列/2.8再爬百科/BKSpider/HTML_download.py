# -*- coding:utf-8 -*-
import requests

class HTML_download:

    def download(self,url):
        if url is None:
            return None

        page = requests.get(url)
        page.encoding = 'utf-8'

        return  page.text