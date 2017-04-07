//
//  HFFormSwitchTVC.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/22.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormSwitchTVC.h"

@implementation HFFormSwitchTVC {
    UILabel *_titleLabel;
    UISwitch *_switch;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorFromRGB(0x555555);
        [self.contentView addSubview:_titleLabel];
        
        _switch = [[UISwitch alloc] init];
        _switch.on = YES;
        _switch.onTintColor = [UIColor orangeColor];
        [_switch addTarget:self action:@selector(switchOperater:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_switch];
    }
    return self;
}

- (void)switchOperater:(UISwitch *)sender {
    self.row.value = [NSNumber numberWithBool:sender.on];
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];

    _switch.on = [row.value boolValue];
    
    _titleLabel.text = row.title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.left    = 16;
    _titleLabel.top     = 12;
    _titleLabel.width   = self.width - _titleLabel.left - 100;
    _titleLabel.height  = 24;
    
    _switch.width   = 55;
    _switch.height  = 31;
    _switch.top     = 10;
    _switch.left    = self.width - _switch.width - 15;
}

@end
