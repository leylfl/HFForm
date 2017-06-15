//
//  UIScrollView+HFFormRefresh.h
//  haofangtuo
//
//  Created by lifenglei on 2017/6/8.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFormRefreshHeaderView.h"
#import "HFFormRefreshFooterView.h"

@interface UIScrollView (HFFormRefresh)

@property (nonatomic, assign) BOOL refreshEnable;

@property (nonatomic, assign) BOOL loadMoreEnable;

@property (nonatomic, assign, readonly) BOOL isLoading;

@property (nonatomic, assign) CGFloat originContentTop;

@property (nonatomic, strong) HFFormRefreshHeaderView *headerView;

@property (nonatomic, strong) HFFormRefreshFooterView *footerView;

@property (nonatomic, strong) id refreshTarget;

@property (nonatomic, assign) SEL refreshSelctor;

@property (nonatomic, strong) id loadMoreTarget;

@property (nonatomic, assign) SEL loadMoreSelctor;

- (void)addTarget:(id)target refreshForSelector:(SEL)selector;

- (void)addTarget:(id)target loadMoreForSelector:(SEL)selector;

- (void)reset;

@end
