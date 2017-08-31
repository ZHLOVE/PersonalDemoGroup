# -*- coding:utf-8 -*-

import base64
import random
import time

import logging
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                    filename='udeean.log',
                    filemode='a')

users = {
    'admin':'YJvp9939',
    'mql':'mql',
    'xiaoqing':'XiaoQ1988!'
}



def create_token(username):
    # token 用户名 随机数 时间戳+7天
    # token = base64.b64encode(str(username) + str(random.random()) + str(time.time() + 3600*24*7))
    timeStr = str(time.time() + 3600*24*7).split('.')[0]#linux时间戳+7天
    tokenStr = timeStr +':'+ str(random.random()) +':'+ str(username)
    token = base64.b64encode(tokenStr)
    logging.info('create_token' + username)
    return token

def verify_token(token):
    try:
        tokenStrList = base64.b64decode(token).split(':')
        logging.info(tokenStrList[2])
        if tokenStrList[-1] in users.keys():
            if int(tokenStrList[0]) > int(time.time()):
                print 1
                return 1
            else:
                return -1
        else:
            return 0
    except:
        return 0
