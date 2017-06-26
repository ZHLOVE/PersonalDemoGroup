# -*- coding:utf-8 -*-

with open('/Users/mbp/Desktop/5.xcappdata/AppData/Documents/gray.text','rb') as f:
    s = f.read()

for i in xrange(16):
    print '{:x} '.format(ord(s[i])),

with open("gray.pbm",'w') as f:
    f.write('P5\n640 480\n255\n')
    f.write(s)


