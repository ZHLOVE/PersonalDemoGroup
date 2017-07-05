class Person(object):
    def __init__(self,name):
        self.name = name
        self.__score = name

xiaoming = Person('xiaoming')
xiaohong = Person('xiaohong')

print xiaoming
print xiaohong.name


class ShiMaNo(object):
    address = 'local'
    def __init__(self, arg):
        self.arg = arg
shimano = ShiMaNo('haha')
print shimano.address


class Person2(object):
    __count = 0
    def __init__(self, name):
        self.name = name
        Person2.__count += 1
        print Person2.__count

p1 = Person2('Bob')
p2 = Person2('Alice')

try:
    print Person2.__count
except AttributeError:
    print 'attributeerror'

class PersonClass(object):
    count = 0
    @classmethod
    def howmany(cls):
        return cls.count
    def __init__(self,name):
        self.name = name
        PersonClass.count = PersonClass.count + 1

p = PersonClass('ii')
print PersonClass.howmany()

print type(p)








































# end
