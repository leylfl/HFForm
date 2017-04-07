//
//  HFFormBasicTableViewCell.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/16.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormBasicTableViewCell.h"

@implementation HFFormBasicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 清除子视图
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorFromRGB(0xe1e1e1);
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    self.row = row;
    
    self.lineView.hidden = row.hideSeperateLine;
    
    for (id key in [row.settings allKeys]) {
        [self setValue:row.settings[key] forKeyPath:key];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lineView.width     = self.width - 32;
    self.lineView.height    = 0.5;
    self.lineView.left      = 16;
    self.lineView.top       = self.height - 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightWithRow:(HFFormBasicModel *)row {
    return 0;
}

@end
