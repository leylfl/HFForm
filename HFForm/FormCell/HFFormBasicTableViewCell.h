//
//  HFFormBasicTableViewCell.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/16.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFormRowModel.h"
#import "UIView+Frame.h"
#import "HFFormHelper.h"

@interface HFFormBasicTableViewCell : UITableViewCell

@property (nonatomic, strong) HFFormRowModel *row;
@property (nonatomic, strong) UIView *lineView;

- (void)updateData:(HFFormRowModel *)row;

+ (CGFloat)tableView:(UITableView *)tableView heightWithRow:(HFFormRowModel *)row indexPath:(NSIndexPath *)indexPath;

@end
