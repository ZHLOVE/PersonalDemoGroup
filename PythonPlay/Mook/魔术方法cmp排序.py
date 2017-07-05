# -*- coding:utf-8 -*-

class Student(object):
    def __init__(self, name,score):
        self.name = name
        self.score = score
    def __str__(self):
        return '(%s:%s)' % (self.name,self.score)
    __repr__ = __str__
    def __cmp__(self, s):
        if self.name < s.name:
            return -1
        elif self.name > s.name:
            return 1
        else:
            return 0

L = [Student('Tim', 99), Student('Bob', 88), Student('Alice', 77)]
# 对 int、str 等内置数据类型排序时，Python的 sorted() 按照默认的比较函数 cmp 排序，但是，如果对一组 Student 类的实例排序时，就必须提供我们自己的特殊方法 __cmp__()：
print sorted(L)
