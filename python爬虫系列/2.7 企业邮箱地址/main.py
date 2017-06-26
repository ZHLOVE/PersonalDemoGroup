# -*- coding:utf-8 -*-


import HuangYe
import CSVData

class SpiderCompanyInfo:
    def __init__(self,base):
        self.baseUrl = base
        self.hy = HuangYe.HuangYe(base)



base = 'http://b2b.huangye88.com/wuxi/'
sp = SpiderCompanyInfo(base)
# sp.hy.openCSV()
companys = sp.hy.getCompanyUrls()
sp.hy.saveToCSV(companys)
print len(companys)



