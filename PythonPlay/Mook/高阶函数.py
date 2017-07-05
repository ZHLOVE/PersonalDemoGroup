# -*- coding:utf-8 -*-

f = abs(-10)
print f
# 高阶函数
# 能够接受其他函数作为参数的函数就叫高阶函数

def add(x, y, f):
    return f(x) + f(y)
# 把abs函数作为第三个参数传入
print add(-5,9,abs)

# map函数
def f(x):
    return x * x
# List中每个元素都做一次f函数运算
print map(f,[1, 2, 3, 4, 5, 6, 7, 8, 9])

# reduce函数
def funReduce(x,y):
    return x+y
print reduce(funReduce,[1,3,5,7,9])

# filter函数
def isOdd(x):
    return x % 2 == 1
# 返回奇数，判断true并组成新的list
print filter(isOdd,[1,4,6,7,9,12,17])

# 利用filter完成删除空字符串
def isNotEmpty(str):
    return str and len(str.strip())>0
print filter(isNotEmpty,['test', None, '', 'str', '  ', 'END'])

# 利用sorted()来排序
def reversed_cmp(x,y):
    if x > y:
        return -1
    if x < y :
        return 1
    return 0

print sorted([36, 5, 12, 9, 21], reversed_cmp)

# python中返回函数
def func_f():
    print 'call f()'
    def g():
        print 'call g()'
    return g
x = func_f()

# python中的闭包
def count():
    fs = []
    for i in range(1, 4):
        def f(j):
            def g():
                return j*j
            return g
        r= f(i)
        fs.append(r)
    return fs
f1, f2, f3 = count()
print f1(), f2(), f3()




# python中的匿名函数  lambda x: x * x 实际上就是：
# def f(x):
    # return x * x
# 关键字lambda 表示匿名函数，冒号前面的 x 表示函数参数。da
