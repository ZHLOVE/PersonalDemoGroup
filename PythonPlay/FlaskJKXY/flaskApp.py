# -*- coding:utf-8 -*-
from flask import Flask,render_template,request,make_response
from os import path
import json

app = Flask(__name__)

@app.route('/index/<user>')
def helloWorld(user):
    return 'helloWorld %s'  % user



# 动态路由，url可变，符合这个规则的URL都可以指向这个函数
@app.route('/user/<userName>')
def user(userName):
    d = {
        'name':userName,
        'age':19
    }
    # 进行JSON序列化
    response = make_response(json.dumps(d))
    return response


#路由器转换器int:float:path:
@app.route('/userId/<int:uid>')
def userID(uid):
    return 'uid: %s' % uid


@app.route('/projects/')
@app.route('/our-works/')
def projects():
    return 'The project page'

@app.route('/login',methods = ['GET','POST'])
def login():
    if request.method == 'POST':
        userName = request.form['username']
        password = request.form['password']
    return render_template('login.html',method=request.method)

@app.route('/upload',methods=['GET','POST'])
def upload():
    if request.method == 'POST':
        f = request.files['file']
        basePath = path.abspath(path.dirname(__file__))
        uploadPath = path.join(basePath,'static/uploads')
        f.save(uploadPath)
        return redirect(url_for('upload'))
    return render_template('upload.html')


@app.errorhandler(404)
def page_not_found(error):
    return render_template('404.html'),404


if __name__ == '__main__':
    app.run(debug=True)
