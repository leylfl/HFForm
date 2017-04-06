//
//  HFFormAddSectionButtonTVC.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/22.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormAddSectionButtonTVC.h"

@implementation HFFormAddSectionButtonTVC {
    UIButton *_addButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.titleLabel.font      = [UIFont boldSystemFontOfSize:14];
        _addButton.layer.borderColor    = [UIColor orangeColor].CGColor;
        _addButton.layer.borderWidth    = 0.5;
        _addButton.clipsToBounds        = YES;
        _addButton.layer.cornerRadius   = 16;
        [_addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:_addButton];
    }
    return self;
}

- (void)addButtonAction {
    if (self.row.valueHandler) {
        self.row.valueHandler(nil);
    }
}

- (void)updateData:(HFFormRowModel *)row
{
    [super updateData:row];
    
    if(row.title) [_addButton setTitle:row.title forState:UIControlStateNormal];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _addButton.width = 130;
    _addButton.height = 35;
    _addButton.centerX = self.width / 2;
    _addButton.top = 20;
}

@end
