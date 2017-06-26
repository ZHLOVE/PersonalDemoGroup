# -*- coding:utf-8 -*-

import requests

r1 = requests.get('http://cuiqingcai.com')
# print type(r1)

# print r1.status_code

# print r1.encoding

# print r1.cookies

url = 'http://httpbin.org/get'

r1 = requests.get('http://httpbin.org/get')

parm = {'key1':'value1','key2':'value2'}

r2 = requests.get(url,params=parm)

# print r2.url

r3 = requests.get('https://github.com/timeline.json', stream=True)
# print r3.raw.read()


r4 = requests.post('http://httpbin.org/post',data=parm)
# print r4.text


payload = {'key1': 'value1', 'key2': 'value2'}
r = requests.post("http://httpbin.org/post", data=payload)
# print r.text

url = 'http://example.com'
r5 = requests.get(url)
# print r5.cookies

s = requests.session()
s.get('http://httpbin.org/cookies/set/sessioncookie/123456789')
r = s.get('http://httpbin.org/cookies')
print r.text

s1 = requests.session()
s1.headers.update({'x-test':'true'})
r = s.get(url, headers={'x-test2': 'true'})







