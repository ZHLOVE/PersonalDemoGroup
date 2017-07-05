# -*- coding:utf-8 -*-

class Person(object):
    def __init__(self, name,gender):
        self.name = name
        self.gender = gender
    def __call__(self, friend):
        print 'My name is %s...' % self.name
        print 'My friend is %s...' % friend



p = Person('Bob','male')
print p.name
p('kkk')
