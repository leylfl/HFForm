//
//  HFFormJumpTVC.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/23.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormJumpTVC.h"

@interface HFFormJumpTVC ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *subfixLabel;

@property (nonatomic, strong) NSDictionary *jumpParams;

@end

@implementation HFFormJumpTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = UIColorFromRGB(0x555555);
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.contentLabel.textColor = UIColorFromRGB(0x222222);
        [self.contentView addSubview:self.contentLabel];
        
        self.subfixLabel = [[UILabel alloc] init];
        self.subfixLabel.font = [UIFont systemFontOfSize:14];
        self.subfixLabel.textColor = UIColorFromRGB(0x878787);
        [self.contentView addSubview:self.subfixLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell)];
        [self.contentView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    self.titleLabel.text = row.title;
    
    self.subfixLabel.hidden = !row.subfix;
    self.contentLabel.text = row.content?: row.placeholder;
    self.contentLabel.textColor = row.content ? UIColorFromRGB(0x222222) : UIColorFromRGB(0x878787);
    self.subfixLabel.text = row.subfix ? row.subfix : @"";
    
    [self setNeedsLayout];
}

- (void)tapCell {
    if (self.row.jumpVC) {
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.left    = 16;
    self.titleLabel.top     = 12;
    self.titleLabel.width   = self.width - _titleLabel.left - 50;
    self.titleLabel.height  = 24;
    
    self.contentLabel.left      = _titleLabel.left;
    self.contentLabel.top       = 38;
    self.contentLabel.width     = _titleLabel.width;
    self.contentLabel.height    = 28;
    
    self.subfixLabel.top    = self.contentLabel.bottom;
    self.subfixLabel.left   = self.titleLabel.left;
    self.subfixLabel.width  = self.titleLabel.width;
    self.subfixLabel.height = self.subfixLabel.hidden ? 0 : 24;
}

@end
