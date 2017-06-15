//
//  HFFormRefreshHeaderView.h
//  haofangtuo
//
//  Created by lifenglei on 2017/6/8.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormRefreshBaseView.h"

@protocol HFFormRefreshHeaderDelegate <NSObject>

- (void)refreshData;

@end

@interface HFFormRefreshHeaderView : HFFormRefreshBaseView

@property (nonatomic, weak) id<HFFormRefreshHeaderDelegate>delegate;

@property (nonatomic, copy) void(^refreshExecute)();

@property (nonatomic, assign) BOOL isLoading;

- (void)endRefresh;

@end
