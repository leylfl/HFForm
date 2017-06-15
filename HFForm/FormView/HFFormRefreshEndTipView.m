//
//  HFFormRefreshEndTipView.m
//  haofangtuo
//
//  Created by lifenglei on 2017/6/9.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormRefreshEndTipView.h"
#import "HFFormHelper.h"

@implementation HFFormRefreshEndTipView {
    UILabel *_tipLabel;
    UIView *_leftView;
    UIView *_rightView;
    
    UIView *_bgView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = UIColorFromRGB(0xa3a3a3);
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.text = @"没有更多了";
        [_bgView addSubview:_tipLabel];
        
        _leftView = [[UIView alloc] init];
        _leftView.backgroundColor = UIColorFromRGB(0xcecece);
        [_bgView addSubview:_leftView];
        
        _rightView = [[UIView alloc] init];
        _rightView.backgroundColor = UIColorFromRGB(0xcecece);
        [_bgView addSubview:_rightView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bgView.left    = 10;
    _bgView.width   = self.width - 20;
    _bgView.top     = 10;
    _bgView.height  = self.height - 20;
    
    [_tipLabel sizeToFit];
    _tipLabel.center = CGPointMake(_bgView.width / 2, _bgView.height / 2);
    
    _leftView.width     = 25;
    _leftView.height    = 1;
    _leftView.right     = _tipLabel.left - 5;
    _leftView.centerY   = _tipLabel.centerY;
    
    _rightView.width    = 25;
    _rightView.height   = 1;
    _rightView.left     = _tipLabel.right + 5;
    _rightView.centerY  = _tipLabel.centerY;
}

- (void)setFrame:(CGRect)frame {
    CGRect tmp      = frame;
    tmp.size.width  = APP_WIDTH;
    tmp.size.height = 54;
    super.frame     = tmp;
}

@end
