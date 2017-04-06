//
//  HFFormPickerView.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/20.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormPickerView.h"
#import "HFFormHelper.h"

@interface HFFormPickerView()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation HFFormPickerView

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, 84.5, APP_WIDTH, 26.5);
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(248, 248, 248);
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.subviews == 0) return;
    
    UIView *bgView = self.subviews.firstObject;
    
    for (UIView *view in self.subviews) {
        if (view != bgView && view.height < 1) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
    
    BOOL hasBgView = NO;
    for (UIView *view in bgView.subviews) {
        if (view == self.bgView) {
            hasBgView = YES;
            break;
        }
    }
    if (!hasBgView) {
        [bgView insertSubview:self.bgView atIndex:0];
    }
}

@end
