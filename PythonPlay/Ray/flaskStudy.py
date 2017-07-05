# -*- coding:utf-8 -*-
from flask import Flask



app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello World!"


# 动态路由
@app.route('/user/<user_id>/<user_name>')
def user(user_id,user_name):
    return 'hello' + user_id + user_name

if __name__ == "__main__":
    app.run(debug=True)
