//
//  HFForm.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/15.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HFFormSectionModel.h"
#import "HFFormRowModel.h"

@class HFFormAdaptor, HFForm;

@protocol HFFormDelegate <NSObject>

@optional

/**
 拿到接口数据后，填充给form的时候，比如图片，传给服务器的是key，但是回填数据的时候还是得用到model里面的图片数据，所以就需要两个字段表示一个是上传给服务器的，一个是自己填数据用的

 @return 替换字典
 */
- (NSDictionary * _Nonnull)replaceProperty;


/**
 表单被选中后的触发

 @param form 表单
 @param indexPath 位置
 @param row row模型
 @param cell cell
 */
- (void)form:(HFForm * _Nonnull)form didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath rowModel:(HFFormRowModel * _Nonnull)row tableViewCell:(UITableViewCell * _Nullable)cell;

/**
 row初始化的时候被触发
 # 一般可以在这个地方设置cell代理等操作

 @param form 表单
 @param indexPath 位置
 @param row 模型
 @param cell cell
 */
- (void)form:(HFForm * _Nonnull)form setRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath rowModel:(HFFormRowModel * _Nonnull)row tableViewCell:(UITableViewCell * _Nullable)cell;

@end

// 数据容器
@interface HFForm : NSObject


/**
 tableView适配器
 */
@property (nonatomic, strong, nullable) HFFormAdaptor *adpator;

/**
 HFForm代理
 */
@property (nonatomic, weak, nullable) id<HFFormDelegate>delegate;

/**
 构建一个section的模型

 @return section模型
 */
+ (HFFormSectionModel * _Nonnull)section;

/**
 构建一个section模型，并且初始化组头部标题

 @param title 头部标题
 @return section模型
 */
+ (HFFormSectionModel * _Nonnull)sectionWithTitle:(NSString * _Nonnull)title;

/**
 构建一个section模型，并且初始化组底部标题

 @param title 底部标题
 @return section模型
 */
+ (HFFormSectionModel * _Nonnull)sectionWithFooterTitle:(NSString * _Nonnull)title;

/**
 构建一个section模型，并且初始化组头部标题和底部标题

 @param title 头部标题
 @param footer 底部标题
 @return section模型
 */
+ (HFFormSectionModel * _Nonnull)sectionWithTitle:(NSString * _Nonnull)title footerTitle:(NSString * _Nonnull)footer;

/**
 构建一个row模型

 @return row模型
 */
+ (HFFormRowModel * _Nonnull)row;

/**
 构建一个HFFormRowType样式的row模型

 @param type row的样式
 @return row模型
 */
+ (HFFormRowModel * _Nonnull)rowWithType:(HFFormRowType)type;

/**
 根据key获取一个section模型

 @param key section的key
 @return section模型
 */
- (HFFormSectionModel * _Nullable)obtainSectionWithKey:(NSString * _Nonnull)key;

/**
 获取所有的row模型

 @return 装有所有row模型的数组
 */
- (NSArray * _Nullable)obtainAllRows;

/**
 根据key查找一个或多个row模型

 @param key row的key
 @return 装有所查找到的row的数组
 */
- (NSArray * _Nullable)obtainRowWithKey:(NSString * _Nonnull)key;

/**
 往已有的表单中添加section数据
 
 #比如添加一个联系人方式组，里面包括姓名，联系电话等，可以用一个section模型装有姓名的row和联系电话的row，然后插入表单

 @param section 要往表单中添加的section模型
 */
- (void)appendSection:(HFFormSectionModel * _Nonnull)section;

/**
 往已有的表单中的某个位置添加section数据

 @param section 要往表单中添加的section模型
 @param index 要插入的位置
 */
- (void)appendSection:(HFFormSectionModel * _Nonnull)section atIndex:(NSUInteger)index;


/**
 往表单添加一个row模型
 
 #默认行为，比如您的需求不需要很多section组分类，那么您构建一个表单的时候，初始化一个row模型，然后直接调用此
 #方法即可，不需要管section模型。

 @param row 要往表单中插入的row模型
 */
- (void)appendRow:(HFFormRowModel * _Nonnull)row;

/**
 往表单的lastRow模型下添加一个或者多个row模型

 @param rows 要往表单中插入的row模型数组
 @param lastRow 要往表单中的哪个row下面进行插入操作
 */
- (void)appendRows:(NSArray <HFFormRowModel *> *_Nonnull)rows below:(HFFormRowModel *_Nonnull)lastRow;

/**
 往表单的某个组(section模型)下面插入一个或者多个row模型
 
 #默认插入到这个组的最后位置

 @param rows 要往表单中插入的row模型数组
 @param section 需要插入到哪个组(section模型)里面
 */
- (void)appendRows:(NSArray <HFFormRowModel *> * _Nonnull)rows inSection:(HFFormSectionModel * _Nonnull)section;

/**
 往表单的某个组的哪个位置插入一个或者多个row模型

 @param rows 要往表单中插入的row模型数组
 @param section 需要插入到哪个组(section模型)里面
 @param index 在组(section模型)的哪个位置
 */
- (void)appendRows:(NSArray <HFFormRowModel *> * _Nonnull)rows inSection:(HFFormSectionModel * _Nonnull)section rowAtSection:(NSUInteger)index;

/**
 删除一个或者多个组(section模型)

 @param sections 装有要删除的组(section模型)的数组
 */
- (void)deleteSections:(NSArray <HFFormSectionModel *> * _Nonnull)sections;

/**
 通过一个key来删除一个组(section模型)

 @param key 需要通过来查找的key
 */
- (void)deleteSectionWithKey:(NSString * _Nonnull)key;

/**
 删除某个位置的组(section模型)

 @param index 需要删除的组(section模型)的位置
 */
- (void)deleteSectionWithIndex:(NSUInteger)index;

/**
 删除一个或者多个row
 
 @param rows 要删除的一个或者多个row
 */
- (void)deleteRows:(NSArray <HFFormRowModel *> * _Nonnull)rows;

/**
 在组(section模型)里删除一个或者多个row

 @param rows 装有要删除的一个或者多个row的数组
 @param section 在哪个组(section模型)里进行删除
 */
- (void)deleteRows:(NSArray <HFFormRowModel *> * _Nonnull)rows inSection:(HFFormSectionModel * _Nonnull)section;

/**
 根据一个key来删除row

 @param key 要删除row的key
 */
- (void)deleRowWithKey:(NSString * _Nonnull)key;

/**
 根据索引获取一个组

 @param index 组的索引
 @return section模型
 */
- (HFFormSectionModel * _Nonnull)sectionOfIndex:(NSUInteger)index;


/**
 在组里的哪个位置获取row

 @param section 要获取row所在的组(section模型)
 @param index 索引
 @return row模型
 */
- (HFFormRowModel * _Nonnull)rowInSection:(HFFormSectionModel * _Nonnull)section ofIndex:(NSUInteger)index;


/**
 获取一共有多少个组

 @return 组的数量
 */
- (NSUInteger)obtainSectionCount;

/**
 表单是否包含某个row模型

 @param row 需要查询的row模型
 @return 包含或者没有包含
 */
- (BOOL)containRow:(HFFormRowModel * _Nonnull)row;

/**
 刷新整个表单数据
 */
- (void)reloadData;

/**
 刷新表单某个row

 @param row 需要被刷新的row
 */
- (void)reloadRow:(HFFormRowModel * _Nonnull)row;

/**
 刷新表单每个cell的高度
 */
- (void)reloadHeight;


/**
 将表单数据导出为字典

 @return 装有导出数据的字典
 */
- (NSDictionary * _Nullable)exportDataToDictionary;

/**
 将数据导出到模型

 @param object 数据导出到的模型
 @return 获得导出数据的模型
 */
- (id _Nullable)exportDataToObject:(id _Nonnull)object;

/**
 导入数据

 @param data 通过这个模型把数据导入到表单
 */
- (void)importData:(id _Nonnull)data;

/**
 模型转字典

 @param model 要转的模型
 @return 字典
 */
- (NSDictionary * _Nullable)dictFromModel:(id _Nonnull)model;

/** 是否编辑过,true为编辑过 */
/**
 检验是否进行编辑过

 @param model 要校验的模型
 @return 有编辑过或者没有编辑过
 */
- (BOOL)checkEditedWithModel:(id _Nullable)model;

/**
 检查row的状态
 
 #检查必填项填写了没有以及检验规则是否通过

 @return 检验通过或者检验没有通过
 */
- (BOOL)checkRowFinished;

@end
