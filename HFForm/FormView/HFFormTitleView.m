//
//  HFFormTitleView.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/17.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormTitleView.h"
#import "UIView+Frame.h"

@implementation HFFormTitleView {
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleLabel];
        
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    }
    return self;
}

- (void)setTitle:(NSString * _Nonnull)title {
    _titleLabel.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.left = 15;
    _titleLabel.top = 0;
    _titleLabel.width = self.width - _titleLabel.left;
    _titleLabel.height = self.height;
}

@end
