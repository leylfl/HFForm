//
//  HFFormSubmitButtonTVC.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/22.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormSubmitButtonTVC.h"

@implementation HFFormSubmitButtonTVC {
    UIButton *_submitButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.backgroundColor = UIColorFromRGB(0x3b4263);
        _submitButton.layer.cornerRadius = 24;
        _submitButton.clipsToBounds = YES;
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_submitButton];
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    if (row.title) [_submitButton setTitle:row.title forState:UIControlStateNormal];
}

- (void)submitDidClicked {
    
    UITableView *tableView = nil;
    if ([self.superview isKindOfClass:[UITableView class]]) {
        tableView = (UITableView *)self.superview;
    }else if ([self.superview.superview isKindOfClass:[UITableView class]]) {
        tableView = (UITableView *)self.superview.superview;
    }
    
    if (tableView) {
        NSIndexPath *indexPath = [tableView indexPathForCell:self];
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    
    if (self.row.valueHandler) {
        self.row.valueHandler(nil);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _submitButton.left = 16;
    _submitButton.width = self.width - 32;
    _submitButton.top = 20;
    _submitButton.height = 48;
}

@end
