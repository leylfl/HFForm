//
//  UIScrollView+HFFormRefresh.m
//  haofangtuo
//
//  Created by lifenglei on 2017/6/8.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "UIScrollView+HFFormRefresh.h"

#import "HFFormHelper.h"

#import <objc/runtime.h>
#import <objc/message.h>

static const NSString *HFFormRefreshEnable;
static const NSString *HFFormLoadMoreEnable;
static const NSString *HFFormoriginContentTop;
static const NSString *HFFormRefreshHeader;
static const NSString *HFFormRefreshFooter;
static const NSString *HFFormRefreshTargetKey;
static const NSString *HFFormRefreshSelctorKey;
static const NSString *HFFormLoadMoreTargetKey;
static const NSString *HFFormLoadMoreSelctorKey;

@implementation UIScrollView (HFFormRefresh)

- (BOOL)refreshEnable {
    return [objc_getAssociatedObject(self, &HFFormRefreshEnable) boolValue];
}

- (BOOL)loadMoreEnable {
    return [objc_getAssociatedObject(self, &HFFormLoadMoreEnable) boolValue];
}

- (BOOL)isLoading {
    return (self.headerView.isLoading || self.footerView.isLoading);
}

- (CGFloat)originContentTop {
    return [objc_getAssociatedObject(self, &HFFormoriginContentTop) floatValue];
}

- (HFFormRefreshHeaderView *)headerView {
    return objc_getAssociatedObject(self, &HFFormRefreshHeader);
}

- (HFFormRefreshFooterView *)footerView {
    return objc_getAssociatedObject(self, &HFFormRefreshFooter);
}

- (id)refreshTarget {
    return objc_getAssociatedObject(self, &HFFormRefreshTargetKey);
}

- (SEL)refreshSelctor {
    return [objc_getAssociatedObject(self, &HFFormRefreshSelctorKey) pointerValue];
}

- (id)loadMoreTarget {
    return objc_getAssociatedObject(self, &HFFormLoadMoreTargetKey);
}

- (SEL)loadMoreSelctor {
    return [objc_getAssociatedObject(self, &HFFormLoadMoreSelctorKey) pointerValue];
}

- (void)setRefreshEnable:(BOOL)refreshEnable {
    objc_setAssociatedObject(self, &HFFormRefreshEnable, @(refreshEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    HFFormRefreshHeaderView *headerView = [[HFFormRefreshHeaderView alloc] init];
    [self addSubview:headerView];
    
    self.headerView = headerView;
    
    WEAK_SELF;
    self.headerView.refreshExecute = ^{
        STRONG_SELF;
        objc_msgSend(self.refreshTarget, self.refreshSelctor);
    };
}

- (void)setLoadMoreEnable:(BOOL)loadMoreEnable {
    objc_setAssociatedObject(self, &HFFormLoadMoreEnable, @(loadMoreEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    HFFormRefreshFooterView *footerView = [[HFFormRefreshFooterView alloc] init];
    [self addSubview:footerView];
    
    self.footerView = footerView;
    
    WEAK_SELF;
    self.footerView.loadMoreExecute = ^{
        STRONG_SELF;
        objc_msgSend(self.loadMoreTarget, self.loadMoreSelctor);
    };
}

- (void)setOriginContentTop:(CGFloat)originContentTop {
    objc_setAssociatedObject(self, &HFFormoriginContentTop, @(originContentTop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHeaderView:(HFFormRefreshHeaderView *)headerView {
    objc_setAssociatedObject(self, &HFFormRefreshHeader, headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFooterView:(HFFormRefreshFooterView *)footerView {
    objc_setAssociatedObject(self, &HFFormRefreshFooter, footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRefreshTarget:(id)refreshTarget {
    objc_setAssociatedObject(self, &HFFormRefreshTargetKey, refreshTarget, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRefreshSelctor:(SEL)refreshSelctor {
    objc_setAssociatedObject(self, &HFFormRefreshSelctorKey, [NSValue valueWithPointer:refreshSelctor], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLoadMoreTarget:(id)loadMoreTarget {
    objc_setAssociatedObject(self, &HFFormLoadMoreTargetKey, loadMoreTarget, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLoadMoreSelctor:(SEL)loadMoreSelctor {
    objc_setAssociatedObject(self, &HFFormLoadMoreSelctorKey, [NSValue valueWithPointer:loadMoreSelctor], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addTarget:(id)target refreshForSelector:(SEL)selector {
    self.refreshTarget = target;
    self.refreshSelctor = selector;
}

- (void)addTarget:(id)target loadMoreForSelector:(SEL)selector {
    self.loadMoreTarget = target;
    self.loadMoreSelctor = selector;
}

- (void)reset {
    [self.headerView endRefresh];
    [self.footerView endLoadMore];
}

@end
