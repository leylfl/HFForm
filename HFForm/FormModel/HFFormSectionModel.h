//
//  HFFormSectionModel.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/15.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HFFormRowModel;

@interface HFFormSectionModel : NSObject
/** key，用于快速找到某个sectionModel，建议写上 */
@property (nonatomic, copy, nonnull) NSString *key;
/** section头部标题 */
@property (nonatomic, copy, nullable) NSString *headerTitle;
/** section底部标题 */
@property (nonatomic, copy, nullable) NSString *footerTitle;
/** section头部view */
@property (nonatomic, strong, nullable) UIView *headerView;
/** section底部view */
@property (nonatomic, strong, nullable) UIView *footerView;
/** section头部高度 */
@property (nonatomic, assign) CGFloat headerHeight;
/** section底部高度 */
@property (nonatomic, assign) CGFloat footerHeight;

/** rows数据 */
@property (nonatomic, strong, readonly, nonnull) NSArray<HFFormRowModel *> *rows;

- (void)appendRow:(HFFormRowModel * _Nonnull )row;

- (void)appendRow:(HFFormRowModel * _Nonnull )row adIndex:(NSUInteger)index;

- (void)deleteRow:(HFFormRowModel * _Nonnull)row;

@end
