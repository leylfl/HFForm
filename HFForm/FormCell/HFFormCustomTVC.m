//
//  HFFormCustomTVC.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/21.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormCustomTVC.h"

@implementation HFFormCustomTVC {
    UIView *_customView;
    NSMutableArray *_views;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (!row.subRows || row.subRows.count == 0) {
        _customView = [[row.view alloc] init];
        [self.contentView addSubview:_customView];
    }else{
        _customView = nil;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_customView) {
        _customView.frame = self.bounds;
    }
    
}

@end
