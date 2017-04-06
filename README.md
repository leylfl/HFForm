# HFForm
HFForm可以快速构建一个表单
###  注意
由于各家公司的UI标准不一样，下图提供的UI部分仅供参考，如有需要可以自行进行定制
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/1.png)
##### `下面演示用到了gif图片，较为卡顿，建议下载demo下来看`
##  使用
#### 控制器需要继承自HFFormTableVC，然后通过下面的代码可以快速的构建一个输入类型
```Objective-C
HFFormRowModel *row;
row = [HFForm rowWithType:HFFormRowTypeDefault];
row.title = @"姓名";
row.placeholder = @"请输入学生姓名";
[self.form appendRow:row];
```
#### 通过reloadData方法将界面显示出来
```Objective-C
[self.form reloadData];
```
#### 比如这个类型的就是一个简单的信息输入框，图片如下：
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/default.gif)

## 样式
除了上面的这个信息输入框，内部已经继承常用的几个样式
###### Picker选择器
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/picker.gif)
###### 图片
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/photo.gif)
###### 描述文本
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/text.gif)

## 动态性
HFForm可以支持动态删除一组内容，或者单行内容

![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/dynamic.gif)

## 更多
更多使用方法请参考demo，或者看内部注释
