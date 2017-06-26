# -*- coding:utf-8 -*-
import re

class readFile:
    def __init__(self):
        file = open(name="池州edm.txt",mode="r")
        print "处理" + file.name
        output = open(name = "已处理"+ file.name,mode='w+')
        content = file.readlines()
        print len(content)
        for i in range(len(content)):
            email = content[i]
            email = email.strip()
            newEmail = email.replace(" ","\n")
            if re.match(pattern="[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?",string=newEmail):
                print newEmail
                output.write("\n")
                output.write(newEmail)


        file.close()
        output.close()
readFile();