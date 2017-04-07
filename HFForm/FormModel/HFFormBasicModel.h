//
//  HFFormBasicModel.h
//  HFFormTest
//
//  Created by lifenglei on 17/4/7.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFFormBasicModel : NSObject

/**
 使用哪个cell
 # 必须要设置的值
 */
@property (nonatomic, strong) Class cell;

/**
 row的值
 # 一般是要返回给服务器的值
 */
@property (nonatomic, strong) id value;

/**
 row的宽度
 # 一般不需要用到，除非一个row上有多个view
 */
@property (nonatomic, assign) CGFloat width;

/**
 row的高度
 # 必须要设置的值
 */
@property (nonatomic, assign) CGFloat height;

/**
 cell的标示符
 # HFForm基于UITableView所以需要用到cell的标示符
 */
@property (nonatomic, copy) NSString *cellIdentifier;


/**
 用于表示什么字段
 # 一般通过key可以快速定位哪个row；也可以设置为跟后台约定的需要上传给后台的key
 */
@property (nonatomic, copy) NSString *key;

@end
