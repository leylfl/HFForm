//
//  HFFormTableVC.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/15.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFForm.h"
#import "HFFormCheck.h"

@interface HFFormTableVC : UIViewController<HFFormDelegate>

@property (nonatomic, strong, readonly) HFForm *form;

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) HFFormRefreshMode refreshMode;

- (void)formRefreshData;

- (void)formLoadMoreData;

- (BOOL)needLoadMoreData;

- (void)endLoadData;

@end
