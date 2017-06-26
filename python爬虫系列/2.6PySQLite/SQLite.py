# -*- coding:utf-8 -*-

import sqlite3

class SQLite(object):
    def __init__(self):
        self.conn = sqlite3.connect('/Users/mbp/Desktop/JA/JA.db')

    def createTable(self):
        self.conn.execute('''CREATE TABLE JA_NAME
               (ID INT PRIMARY KEY     NOT NULL,
               NAME           TEXT,
               NAME_URL       TEXT);''')
        print '建表成功'

    def insertNameAndNameURL(self,name,nameUrl):
        cursor = self.conn.cursor()
        cursor.execute("INSERT INTO JA_NAME (NAME,NAME_URL) VALUES (?,?)",(name,nameUrl))
        self.conn.commit()

# conn = sqlite3.connect('/Users/mbp/Desktop/JA/JA2.db')
# # conn.execute('''CREATE TABLE JA_NAME
# #        (ID INT PRIMARY KEY     NOT NULL,
# #        NAME           TEXT,
# #        NAME_URL       TEXT);''')
#
# # conn.execute('''CREATE TABLE JA_NAME
# #        (ID INTEGER PRIMARY KEY AUTOINCREMENT,
# #        NAME           TEXT,
# #        NAME_URL       TEXT);''')
#
# print '连接数据库成功'
#
# name = 'TOM'
# nameURL = 'dfaffda'
# cursor = conn.cursor()
# cursor.execute("INSERT INTO JA_NAME (NAME,NAME_URL) VALUES (?,?)",(name,nameURL));
#
# conn.commit()
# conn.close()


