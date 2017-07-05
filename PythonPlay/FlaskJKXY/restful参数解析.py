# -*- coding:utf-8 -*-

from flask import Flask
from flask_restful import reqparse,Api,Resource,fields,marshal_with

app = Flask(__name__)
api = Api(app)

# 关于参数解析部分
# 一组模拟的数据
TODOS = {
    't1':{'task':1},
    't2':{'task':2},
    't3':{'task':3},
    }

# 定义允许的参数为task,类型为int,以及错误时的提示
parser = reqparse.RequestParser()
parser.add_argument('task',type=int, help='参数错误')

class ToDoList(Resource):
    def get(self):
        return TODOS,200,{'Etag':'some-opaque-string'}
    def post(self):
        args = parser.parse_args()
        todo_id = int(max(TODOS.keys()).lstrip('todo')) + 1
        todo_id = 'todo%i' % todo_id
        TODOS[todo_id] = {'task':args['task']}
        return TODOS[todo_id],201
api.add_resource(ToDoList,'/todos','/all_tasks')

if __name__ == '__main__':
    app.run(debug=True)
