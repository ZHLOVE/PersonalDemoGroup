# -*- coding:utf-8 -*-
# Python是如何把任意变量变成str的
# 任何数据类型的实例都有一个魔术方法



# 只需要编写用到的特殊方法
# 有关联的特殊方法都必须实现



class Person(object):

    def __init__(self, name, gender):
        self.name = name
        self.gender = gender

class Student(Person):

    def __init__(self, name, gender, score):
        super(Student, self).__init__(name, gender)
        self.score = score

    def __str__(self):
        return '(student:%s,%s,%d)' %(self.name,self.gender,self.score)
        __repr__=__str__

s = Student('Bob', 'male', 88)
