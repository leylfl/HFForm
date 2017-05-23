//
//  HFFormRowModel.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/15.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFormBasicModel.h"

/**
 row的样式
 # 提供了默认的几个样式
 */
typedef NS_ENUM(NSUInteger, HFFormRowType) {
    HFFormRowTypeDefault = 100,
    HFFormRowTypeTitle,         // 标题
    HFFormRowTypeAlbum,         // 选择图片
    HFFormRowTypeOptions,       // 多选项
    HFFormRowTypeDatePicker,    // 日期选择器
    HFFormRowTypeSwitch,        // 选择开关
    HFFormRowTypeText,          // 描述类的控件，比如看房描述，默认高度自动计算，其他情况初始化的时候覆盖
    HFFormRowTypeJump,          // 跳转，默认高度74，其他情况初始化的时候覆盖，不要在这里面改
    HFFormRowTypeSubmit,        // 提交按钮
    HFFormRowTypeAddSection,    // 添加一个组
    HFFormRowTypeCustom,        // 自定义
    HFFormRowTypeLocation,      // 定位
    HFFormRowTypeCheckBox,      // 复选框
    HFFormRowTypeTags,          // 标签类
    HFFormRowTypeUnknow
};

/**
 刷新方式
 */
typedef NS_ENUM(NSUInteger, HFFormRefreshType) {
    HFFormRefreshTypeAll = 200,   // 全部刷新
    HFFormRefreshTypeRow,         // 仅仅刷新某个cell
    HFFormRefreshTypeHeight       // 只刷新高度
};

@class HFFormRowModel;

typedef void(^HFFormRowValueChangedHandler)(id value);
typedef void(^HFFormRowReloadHandler)(HFFormRefreshType type);
typedef void(^HFFormRowValueInvalidHandler)();
typedef NSArray <HFFormRowModel *>*(^HFFormRowValueSubRowsHandler)();
typedef NSError *(^HFFormRowCheckHandler)(HFFormRowModel *row);
typedef NSDictionary *(^HFFormRowSettingHandler)();
typedef NSString *(^HFFormRowTitleHandler)();

@interface HFFormRowModel : HFFormBasicModel

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 内容
 # 用于展示的内容，一般回填数据回去的时候，需要展示的内容，可以赋值给这个属性
 */
@property (nonatomic, copy) NSString *content;

/**
 副标题
 */
@property (nonatomic, copy) NSString *subfix;

/**
 键盘类型
 */
@property (nonatomic, assign) UIKeyboardType keyboardType;

/**
 输入字符数量的限制
 */
@property (nonatomic, assign) unsigned int numberOfLimit;

/**
 row的类型
 */
@property (nonatomic, assign) HFFormRowType type;

/**
 是否允许编辑
 # 默认NO，允许编辑
 */
@property (nonatomic, assign) BOOL disable;


/**
 是否必填项
 # 表单中可能有些选项不是必填的
 */
@property (nonatomic, assign) BOOL neccesary;

/**
 是否需要展示row与row之间的分割线
 # 默认YES，是展示的
 */
@property (nonatomic, assign) BOOL hideSeperateLine;

/**
 自定义view
 # 除了制定cell来指定自定义的cell，也可以使用row的type为HFFormRowTypeCustom，然后赋值一个自定义的view给它来显示定义的view
 */
@property (nonatomic, strong) Class view;

/**
 跳转页面
 # 一般用于row为HFFormRowTypeJump，给定需要跳转的页面
 */
@property (nonatomic, strong) NSString *jumpVC;

/**
 用于一个row上多个自定义view
 # 每个view都有其对应的一个rowModel
 */
@property (nonatomic, strong) NSArray <HFFormRowModel *> *subRows;

/**
 刷新操作
 # row调用此回调来刷新数据等
 */
@property (nonatomic, copy) HFFormRowReloadHandler reloadHandler;

/**
 值改变的回调
 # 当给row赋值或者重新赋值的时候的回调
 */
@property (nonatomic, copy) HFFormRowValueChangedHandler valueHandler;

/**
 给row的自定义设置
 # 比如给cell的成员变量设置一些值
 */
@property (nonatomic, copy) HFFormRowSettingHandler settingsHandler;

/**
 读取给row设置的自定义设置
 */
@property (nonatomic, strong, readonly) NSDictionary *settings;

/**
 自定义需要给title设置的标题
 # 通常需要经过一系列运算才能得到的标题，为了结构好看，可以使用这个属性，让计算在block体内
 */
@property (nonatomic, copy) HFFormRowTitleHandler titleHandler;

/**
 检查值是否符合要求
 # 有时候给需要的值进行限定，比如长度不允许冲过100之类的限制等待
 */
@property (nonatomic, copy) HFFormRowCheckHandler checkHandler;

/**
 校验不合格的回调
 # checkHandler给出判断规则后，校验不通过会触发这个回调
 */
@property (nonatomic, copy) HFFormRowValueInvalidHandler invalidHandler;

#pragma mark - 一般用于多选项PickerView

/**
 每列多选项的数据
 */
@property (nonatomic, strong) NSArray *multiDatas;

/**
 装有rows数组的回调
 # 用于展示多选项PickerView，装有几个数组就显示几列
 */
@property (nonatomic ,copy) HFFormRowValueSubRowsHandler subRowsHandler;

/**
 多选项pickerview里面数据对应的value值
 # 有时候我们从服务器取到数据转成模型后，再给pickerview，通过这个属性来取对应的value值
 */
@property (nonatomic, copy) NSString *valueKey;

/**
 多选项pickerview里面数据对应的id值
 # 有时候我们从服务器取到数据转成模型后，再给pickerview，通过这个属性来取对应的id值
 */
@property (nonatomic, copy) NSString *idKey;


/**
 多选项pickerview里面数据默认停在哪一行，业务复杂啊
 # 格式：填入比如@"1"即可，注意是从0开始的，即第一行是0
 */
@property (nonatomic ,strong) NSNumber *defaultSelectRow;


/**
 选择的选择项不能小于某个哪行
 */
@property (nonatomic, strong) NSNumber *miniSelect;


/**
 小于最小行后给出的提示
 */
@property (nonatomic, strong) NSString *miniSelectError;


/**
 追加配置
 
 @param dict 配置
 */
- (void)appendSettings:(NSDictionary *)dict;

@end
