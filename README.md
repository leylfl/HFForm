# HFForm
HFForm可以快速构建一个表单
###  注意
由于各家公司的UI标准不一样，下图提供的UI部分仅供参考，如有需要可以自行进行定制
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/1.png)

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
###### 开关
```Objective-C
HFFormRowModel *row;
row = [HFForm rowWithType:HFFormRowTypeSwitch];
row.title = @"是否本地户籍";
row.value = @1;
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/switch.png)
###### 多选项选择器
```Objective-C
HFFormRowModel *row;
row = [HFForm rowWithType:HFFormRowTypeOptions];
row.title = @"性别";
row.placeholder = @"请选择学生性别";
row.subRowsHandler = ^{
  NSMutableArray *array = @[].mutableCopy;
  HFFormRowModel *relRow = [HFForm row];
  relRow.multiDatas = @[@"男",@"女"];
  [array addObject:relRow];
  return array;
};
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/options.png)
###### 时间选择器
```Objective-C
HFFormRowModel *row;
row = [HFForm rowWithType:HFFormRowTypeDatePicker];
row.title = @"出生日期";
row.placeholder = @"选择出生日期";
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/date.png)
###### 图片
```Objective-C
HFFormRowModel *row;
row = [HFForm rowWithType:HFFormRowTypeDatePicker];
row.title = @"出生日期";
row.placeholder = @"选择出生日期";
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/photo.png)
###### 描述文本
```Objective-C
HFFormRowModel *row;
row = [HFForm rowWithType:HFFormRowTypeText];
row.title = @"学生评价";
row.placeholder = @"请输入对学生的评价";
row.subfix = @"至少输入100个字";
row.settingsHandler = ^{
  return @{@"minCount": @100};
};
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/text.png)

## 动态性
 HFForm可以支持动态新增或者删除一组内容，或者单行内容

![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/dynamic.gif)

## 更多
更多使用方法请参考demo，或者看内部注释
