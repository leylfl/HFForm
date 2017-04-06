//
//  HFFormSupplementaryTVC.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/22.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormSupplementaryTVC.h"
#import "NSBundle+HFForm.h"

@interface HFFormSupplementaryTVC()

@property (nonatomic, copy) NSString *jumpH5;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subLabel;

@end

@implementation HFFormSupplementaryTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = UIColorFromRGB(0x555555);
        [self.contentView addSubview:self.titleLabel];
        
        self.subLabel = [[UILabel alloc] init];
        self.subLabel.font = [UIFont systemFontOfSize:14];
        self.subLabel.textAlignment = NSTextAlignmentRight;
        self.subLabel.textColor = UIColorFromRGB(0x878787);
        [self.contentView addSubview:self.subLabel];
        
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    self.titleLabel.text = row.title;
    self.subLabel.text   = row.subfix;
    
    [self setNeedsLayout];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.left    = 16;
    self.titleLabel.top     = 12;
    self.titleLabel.width   = [HFFormHelper sizeWithText:self.titleLabel.text font:self.titleLabel.font maxSize:CGSizeMake(self.width / 3, 24)].width + 5;
    self.titleLabel.height  = 24;
    
    self.subLabel.width     = [HFFormHelper sizeWithText:self.subLabel.text font:self.subLabel.font maxSize:CGSizeMake(self.width / 3, 24)].width + 5;
    self.subLabel.height    = 24;
    self.subLabel.left      = self.width - self.subLabel.width - 40;
    self.subLabel.top       = 12;
}

@end
