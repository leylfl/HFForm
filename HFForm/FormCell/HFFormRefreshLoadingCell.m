//
//  HFFormRefreshLoadingCell.m
//  haofangtuo
//
//  Created by lifenglei on 2017/6/9.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormRefreshLoadingCell.h"

@implementation HFFormRefreshLoadingCell {
    UIActivityIndicatorView *_indicatorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:_indicatorView];
        
        [_indicatorView startAnimating];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _indicatorView.center = CGPointMake(self.width / 2, self.height / 2);
}

@end
