//
//  HFFromDatePickerTVC.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/22.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFromDatePickerTVC.h"
#import "HFFormDatePicker.h"

@implementation HFFromDatePickerTVC{
    UILabel             *_titleLabel;
    UILabel             *_contentLabel;
    HFFormDatePicker    *_datePicker;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorFromRGB(0x555555);
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_contentLabel];
        
        _datePicker = [[HFFormDatePicker alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, 240)];
        _datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
        __weak typeof(self)weakSelf = self;
        _datePicker.doneBlock = ^{
            __strong typeof(weakSelf)self = weakSelf;
            [self resignFirstResponder];
            
            [self _updateValue];
        };
        
        _datePicker.cancelBlock = ^{
            __strong typeof(weakSelf)self = weakSelf;
            [self resignFirstResponder];
        };
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    _titleLabel.text = row.title;
    
    if (!row.value) {
      _contentLabel.text = row.placeholder;
    }else{
        // 默认传进来的是时间错，需要注意
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSString stringWithFormat:@"%@",row.value].doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy年MM月dd日";
        _contentLabel.text = [formatter stringFromDate:date];
    }
    
    _contentLabel.textColor = row.value ? UIColorFromRGB(0x222222) : UIColorFromRGB(0xe1e1e1);
}

- (BOOL)canBecomeFirstResponder {
    return true;
}

- (BOOL)canResignFirstResponder {
    return true;
}

- (UIView *)inputView {
    return _datePicker;
}

- (void)_updateValue {
    _contentLabel.textColor = UIColorFromRGB(0x222222);
    
    self.row.value = [NSString stringWithFormat:@"%ld",(long)[_datePicker.datePicker.date timeIntervalSince1970]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    _contentLabel.text = [formatter stringFromDate:_datePicker.datePicker.date];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.left    = 16;
    _titleLabel.top     = 12;
    _titleLabel.width   = self.width - _titleLabel.left - 50;
    _titleLabel.height  = 24;
    
    _contentLabel.left      = _titleLabel.left;
    _contentLabel.top       = 38;
    _contentLabel.width     = _titleLabel.width;
    _contentLabel.height    = 28;
}

@end
