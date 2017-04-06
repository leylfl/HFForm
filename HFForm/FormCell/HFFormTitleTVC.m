//
//  HFFormTitleTVC.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/20.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormTitleTVC.h"

@implementation HFFormTitleTVC {
    UILabel     *_titleLabel;
    UIButton    *_button;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x878787);
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:12];
        [_button setTitle:@"删除" forState:UIControlStateNormal];
        [_button setTitleColor:UIColorFromRGB(0x878787) forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(actionDidExecute) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    _titleLabel.text = row.title;
}

- (void)actionDidExecute {
    if (self.row.valueHandler) {
        self.row.valueHandler(nil);
    }
}

- (void)layoutSubviews {
    _titleLabel.left    = 16;
    _titleLabel.top     = 20;
    _titleLabel.width   = self.width - _titleLabel.left - 40;
    _titleLabel.height  = 24;
    
    _button.width       = 30;
    _button.height      = 30;
    _button.top         = 24;
    _button.right       = self.width - 16;
}


@end
