# -*- coding:utf-8 -*-
# 定义了一个函数，在函数调用的时候动态的修改这个函数
# 接收一个函数，对其包装，然后返回一个新函数

def f1(x):
    return x * 2

# 装饰器函数
def new_fn(f):
    def fn(x):
        print ('call' + f.__name__ + '()')
        return f(x)
    return fn

g1 = new_fn(f1)
print (g1(5))

# 彻底隐藏f1原始定义
f1 = new_fn(f1)
print (f1(5))


@new_fn
def f2(x):
    return x * 2

print (f2(6))

# 装饰器可以极大的简化代码，避免每个函数编写重复性代码
# 打印日志： @log
# 检测性能： @performance
# 数据库失误： @transaction
# URL路由： @post('/register')

# @log 自适应任何参数定义的函数，可以利用Python的 *args 和 **kw，保证任意个数的参数总是能正常调用：
def log(f):
    def fn(*args, **kw):
        print ('call: ' + f.__name__ + '()...')
        return f(*args, **kw)
    return fn

# @log
# def factorial(n):
#     return reduce(lambda x,y: x*y, range(1, n+1))
# print (factorial(10))



@log
def add(x, y):
    return x + y




# 不带参数的装饰器

import time
def performance(func):
    def print_time(*args, **kw):
        print ('call: ' + func.__name__ + '()' + time.strftime('%Y-%m-%d',time.localtime(time.time())))
        return func(*args, **kw)
    return print_time



# @performance
# def factorial(n):
#     for i in range(1,999):
#         x = 1
#     return reduce(lambda x,y: x*y, range(1, n+1))




# 带参数的装饰器,类似这样
# @log('DEBUG')
# def my_func():
    # pass
def log2(prefix):
    def log_decorator(f):
        def wrapper(*args, **kw):
            print ('[%s] %s()...' % (prefix, f.__name__))
            return f(*args, **kw)
        return wrapper
    return log_decorator

@log2('DEBUG')
def test():
    pass




def performanceWith(unit):
    def perf_decorator(f):
        def wrapper(*args, **kw):
            t1 = time.time()
            r = f(*args, **kw)
            t2 = time.time()
            t = (t2 - t1)*1000 if unit =='ms' else (t2 - t1)
            print ('call %s() in %f %s'%(f.__name__, t, unit))
            return r
        return wrapper
    return perf_decorator

# @performanceWith('ms')
# def factorialWith(n):
#     return reduce(lambda x,y: x*y, range(1, n+1))




# 类装饰器
class Foo(object):
    def __init__(self,func):
        self._func = func
    def __call__(self):
        print ('class decorator running')
        self._func()
        print('class decorator ending')

@Foo
def bar():
    print ('bar')

bar()

# 偏函数functools.partial就是帮助我们创建一个偏函数的，不需要我们自己定义int2()，可以直接使用下面的代码创建一个新的函数int2：
import functools
int2 = functools.partial(int,base=2)

# print int2('1000000')





import os
# print os.path.isdir('/Users/mbp/Desktop/Shimano')
# print os.path.isfile('/Users/mbp/Desktop/Shimano/装饰器.py')


import sys

print  ('版本' + sys.version)

# try:
#     from cStringIO import StringIO
#     print ('import cStringIO')
# except ImportError:
#     from StringIO import StringIO
#     print ('import StringIO')

print (10/3)



























































































































# end
