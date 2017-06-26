# 160304星期五
##教学内容
  * storyboard创建表格
  * 表格操作



####错误信息:
 ```
reason: 'unable to dequeue a cell with identifier Cell - must register a nib or a class for the identifier or connect a prototype cell in a storyboard'
```
原因:没有找到对应Identifier的原型单元格
检查storyboard中原型单元格的identifer，和代码中是否一致，或者如果没有使用storyboard，则检查有没有注册对单元格模板类