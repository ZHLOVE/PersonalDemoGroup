# -*- coding:utf-8 -*-
class Person(object):
    def __init__(self, name,gendar):
        self.name = name
        self.gendar = gendar
    def whoAmI(self):
        print '我是一个人'

class Student(Person):
    def __init__(self,name,gendar,score):
        super(Student,self).__init__(name,gendar)
        self.score = score
    def whoAmI(self):
        print '我是一个警察'

xiaoming = Student(name='xiaoming',gendar='男',score='99')
print xiaoming.gendar

class Teacher(Person):
    def __init__(self, name,gender,course):
        super(Teacher,self).__init__(name,gender)
        self.course = course
    def whoAmI(self):
        print '我是一个好人'

laoWang = Teacher(name='老王',gender='女',course='语文老师')
print laoWang.gendar
laoWang.whoAmI()
print laoWang.course

x = isinstance(laoWang,Person)
print x
