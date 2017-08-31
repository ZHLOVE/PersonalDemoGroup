# -*- coding:utf-8 -*-
from flask import Flask, request, redirect, url_for
import LeQiMySQL
import json
import datetime
import auth
import logging
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                    filename='udeean.log',
                    filemode='a')


def after_request(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'PUT,GET,POST,DELETE'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type,Authorization'
    return response



def create_app():
    app = Flask(__name__)
    app.after_request(after_request)
    database = LeQiMySQL.LeQiMySQL()



    @app.route("/")
    def hello():
        # t = request.args.get('text')
        return redirect('http://www.wxtglyy.com/')

    # 登录
    @app.route('/login', methods=['POST'])
    def login():
        data = request.get_data()
        jsonRequest = json.loads(data)
        if request.method == 'POST':
            username = jsonRequest['username']
            passwd = jsonRequest['passwd']
            if username in auth.users.keys():
                if passwd == auth.users[username]:
                    token = auth.create_token(username)
                    resp = {'token': '', 'username': ''}
                    resp['token'] = token
                    resp['username'] = username
                    return json.dumps(resp),200
                else:
                    return 'Login Error',401
            else:
                return 'userName Error',402

        else:
            return 'Error',403


    @app.route('/token', methods=['POST'])
    def test():
        token = request.get_data()
        jsonRequest = json.loads(token)
        if auth.verify_token(jsonRequest.get('accessToken')) == 1:
            return 'token success',200
        else:
            return 'token error',402


    # 新增规格
    @app.route("/photo_Spec",methods=['POST', 'DELETE'])
    def add_Spec():
        data = request.get_data()
        jsonRequest = json.loads(data)
        time_stamp = datetime.datetime.now()

        if request.method == 'POST':
            try:
                database.appSpec(jsonRequest)
                print time_stamp.strftime('%Y.%m.%d-%H:%M:%S')
                return 'add Success'
            except KeyError:
                print 'add_Spec:KeyError'
                return 'KeyError'
        if request.method == 'DELETE':
            try:
                spec_id = jsonRequest['spec_id']
                database.deleteSpec(spec_id)
                print time_stamp.strftime('%Y.%m.%d-%H:%M:%S')
                return 'delete Success'
            except KeyError:
                print 'add_Spec:KeyError'
                return 'KeyError'

    # 获取当前审核状态
    @app.route("/get_audit",methods=['GET'])
    def get_audit():
        result = database.getAudit()
        return json.dumps(result)

    # 设置审核状态
    @app.route("/set_audit/",methods=['GET'])
    def set_audit():
        allArgs = request.args.to_dict()
        database.setAudit(allArgs)
        return 'set complete'

    # 查询冲印订单
    @app.route("/search_PrintOrder/<string>")
    def searchPrintOrder(string):
        searchResult = database.searchPrintOrderWithPhoneNumber(string)
        return json.dumps(searchResult)

    return app
