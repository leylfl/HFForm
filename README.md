# HFForm
嗨，HFForm是一个可以快速构建一个表单的框架，并在最近新增了刷新控件，于是把应用场景拓展到了可以构建详情页或者列表等页面，使用这个控件可以快速完成一个页面的搭建。

##  0x01 如何搭建表单？
UI风格可以根据各自需求进行更改，这里以样例来进行介绍
### ① 基础输入控件
#### 代码示例如下：
```Objective-C
HFFormRowModel *row;
row             = [HFForm rowWithType:HFFormRowTypeDefault];
row.title       = @"姓名";
row.placeholder = @"请输入学生姓名";
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/default.png)

### ② 开关控件
#### 代码示例如下：
```Objective-C
row             = [HFForm rowWithType:HFFormRowTypeSwitch];
row.title       = @"性别";
row.placeholder = @"请选择学生性别";
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/switch.png)

### ③ pickerView控件
#### 代码示例如下：(示例图是动图，可能较慢)
```Objective-C
row                 = [HFForm rowWithType:HFFormRowTypeOptions];
row.title           = @"与学生关系";
row.placeholder     = @"请选择与学生的关系";
row.subRowsHandler  = ^{
        NSMutableArray *array = @[].mutableCopy;
        HFFormRowModel *relRow = [HFForm row];
        relRow.multiDatas = @[@"父亲", @"母亲", @"爷爷", @"奶奶", @"外公", @"外婆", @"其他亲戚"];
        [array addObject:relRow];
        return array;
    };
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/pickerView.gif)

### ④ 单选框控件
#### 代码示例如下：(示例图是动图，可能较慢)
```Objective-C
row                     = [HFForm rowWithType:HFFormRowTypeCheckBox];
row.title               = @"学生概况";
row.defaultSelectRow    = @1;
row.multiDatas          = @[@"本校生源", @"借读生", @"转校生", @"留级生"];
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/checkbox.gif)

### ⑤ 标签控件
#### 代码示例如下：(示例图是动图，可能较慢)
```Objective-C
row                 = [HFForm rowWithType:HFFormRowTypeTags];
row.title           = @"学生印象";
row.multiDatas      = @[@"内向", @"外向", @"热于助人", @"尊敬师长", @"有礼貌", @"性格倔强", @"敢于发言", @"调皮", @"容易相处"];
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/tags.gif)

### ⑥ 长文本输入控件(自动匹配高度)
#### 代码示例如下：(示例图是动图，可能较慢)
```Objective-C
row                 = [HFForm rowWithType:HFFormRowTypeText];
row.title           = @"学生评价";
row.placeholder     = @"请输入对学生的评价";
row.subfix          = @"至少输入100个字";
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/text.gif)

### ⑦ 选择图片控件
#### 代码示例如下：(示例图是动图，可能较慢)
```Objective-C
row                 = [HFForm rowWithType:HFFormRowTypeAlbum];
row.title           = @"学生照片";
[self.form appendRow:row];
```
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/photo.gif)

### ⑧ 通过reloadData方法将界面显示出来
#### 代码示例如下：
```Objective-C
[self.form reloadData];
```
##  0x02 支持自定义
### 正因为支持自定义所以也可以用于构建详情或者列表等页面
#### 代码示例如下：
```Objective-C
row                 = [HFForm row];
row.cell            = [自定义的cell class]; // 自定义的cell需要继承HFFormBasicTableViewCell
row.height          = 44;
[self.form appendRow:row];
```

##  0x03 支持动态性
### 通过form内部的append或者delete相关方法，可以灵活新增或者删除控件
#### 示例图是动图，可能较慢
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/dynamic.gif)

##  0x04 代理
### 通过实现form的代理，可以获得被点击后的响应
```Objective-C
- (void)form:(HFForm * _Nonnull)form didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath rowModel:(HFFormRowModel * _Nonnull)row tableViewCell:(UITableViewCell * _Nullable)cell; // 被点击后的响应
- (void)form:(HFForm * _Nonnull)form setRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath rowModel:(HFFormRowModel * _Nonnull)row tableViewCell:(UITableViewCell * _Nullable)cell;// 初始化控件后的响应，可以在这个里面设置控件代理等
```
##  0x05 刷新  
### 新增了刷新控件，支持上拉刷新和下拉加载
#### ① 启用
```Objective-C
self.refreshMode = HFFormRefreshModeRefresh | HFFormRefreshModeLoadMore;  // 一共三种HFFormRefreshModeRefresh、HFFormRefreshModeLoadMore和HFFormRefreshModeLoadMoreManual，后面两个都是启用加载更多，区别是前者是自动加载更多，后者是需要手动去拉加载更多
```
#### ② 关闭刷新和加载更多
```Objective-C
[self endLoadData];
```

#### ③ 需要实现的代理方法 
```Objective-C
- (void)formRefreshData; // 刷新成功后会调用这个方法，这里一般放请求数据的代码实现
- (void)formLoadMoreData; // 加载更多成功后会调用这个方法，这里一般放请求数据的代码实现
- (BOOL)needLoadMoreData;  // 是否还有更多的数据
```

#### 示例图片如下:(动图加载可能较慢)
![](https://github.com/leylfl/HFForm/blob/master/HFFormTest/Photos/dynamic.gif)

## 更多
#### 还实现了比如一键模型转字典，一键回调表单数据等方法
更多使用方法请参考demo，或者看内部注释
