# -*- coding:utf-8 -*-

def fun_var_args(self, *args):
    print 'args:',self
    for value in args:
        print 'a arg:',value


fun_var_args(1,'two',3,4,5)

def fun_var_kwargs(farg, **kw):
    print "arg:", farg
    for key in kw:
        print "another keyword arg: %s: %s" % (key, kw[key])


fun_var_kwargs(farg=1, myarg2="two", myarg3=3) # myarg2和myarg3被视为key， 感觉**kwargs可以当作容纳多个key和value的dictionary
