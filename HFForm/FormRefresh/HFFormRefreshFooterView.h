//
//  HFFormRefreshFooterView.h
//  haofangtuo
//
//  Created by lifenglei on 2017/6/8.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormRefreshBaseView.h"

@protocol HFFormRefreshFooterDelegate <NSObject>

- (void)loadMore;

@end

@interface HFFormRefreshFooterView : HFFormRefreshBaseView

@property (nonatomic, weak) id<HFFormRefreshFooterDelegate>delegate;

@property (nonatomic, copy) void(^loadMoreExecute)();

@property (nonatomic, assign) BOOL isLoading;

- (void)beginLoadMore;

- (void)endLoadMore;

@end
