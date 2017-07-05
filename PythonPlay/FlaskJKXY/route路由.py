# -*- coding:utf-8 -*-
from flask import Flask,request

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello world!'


# POST方法
@app.route('/user',methods=['POST'])
def hello_user():
    return 'hello user'


# http://localhost:5000/user/12312421
@app.route('/user/<id>')
def user_id(id):
    return 'hello user ID' + id



# http://localhost:5000/query_user?id=12312421
@app.route('/query_user')
def query_user():
    id = request.args.get('id')
    return 'query Request' + id

if __name__ == '__main__':
    app.run()
